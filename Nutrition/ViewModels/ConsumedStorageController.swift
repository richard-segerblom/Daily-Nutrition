//
//  ConsumedStorageController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-02.
//

import Foundation
import CoreData
import Combine

final class ConsumedStorageController: ObservableObject {
    @Published var today: [ConsumedController] = []
    @Published var latest: [ConsumedController] = []
    @Published var nutritionToday: NutritionProfileController
    
    let persistenceController: PersistenceController
    let userController: UserController
            
    private var cancellable: AnyCancellable?
    
    init(persistenceController: PersistenceController, userController: UserController) {
        self.persistenceController = persistenceController
        self.userController = userController
        self.nutritionToday = NutritionProfileController(profile: userController.profile, required: userController.profile)
        
        fetchConsumed { self.sumNutritionToday() }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeNotification(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        cancellable = self.userController.$user.sink { newUser in
            guard let user = newUser else { return }
            self.today.forEach { $0.required = user.nutritionProfile }
            self.latest.forEach { $0.required = user.nutritionProfile }
            self.sumNutritionToday()
        }
            
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func onChangeNotification(_ notification: Notification) {
        var shouldReload = false
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> {
                shouldReload = !insertedObjects.filter { $0 is CDConsumed }.isEmpty
        }
    
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            shouldReload = !deletedObjects.filter { $0 is CDConsumed }.isEmpty
        }
        
        if shouldReload {
            fetchConsumed { self.sumNutritionToday() }
        }
    }
    
    func fetchConsumed(completion: (() -> Void)? = nil) {
        let latest = CDConsumed.latest(context: persistenceController.container.viewContext)
            .map { ConsumedController(consumed: $0, required: userController.profile, persistenceController: persistenceController) }
        let today = latest.filter { Calendar.current.isDateInToday($0.date) }
        self.latest = latest
        self.today = today
        completion?()
    }
    
    private func sumNutritionToday() {                
        DispatchQueue.global(qos: .background).async {
            var all: [Nutrient] = []
            for key in NutrientKey.allCases {
                let unit = self.userController.profile.nutrients[key]?.unit ?? .unknown
                all.append(NewNutrient(key: key, value: 0, unit: unit))
            }
            
            var profile: NutritionProfile = NewNutritionProfile(nutrients: all)
            for consumed in self.today {
                if let meal = consumed.meal {
                    profile = profile.merged(other: meal.makeNutritionProfile())
                } else if let eatable = consumed.eatable {
                    profile = profile.merged(other: eatable.nutritionProfile)
                }
            }
            
            DispatchQueue.main.async {
                self.nutritionToday = NutritionProfileController(profile: profile, required: self.userController.profile)
            }
        }
    }
}
