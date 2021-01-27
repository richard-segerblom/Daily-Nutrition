//
//  AppController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-06.
//

import Foundation

final class AppController: ObservableObject {
    @Published var isContentLoaded = false
    
    private let userDefaults: UserDefaults
    
    var persitence: PersistenceController! = nil
    var user: UserController! = nil
    var consumedStorage: ConsumedStorageController! = nil
    var foodStorage: FoodStorageController! = nil
    var mealStorage: MealStorageController! = nil
    
    init() { userDefaults = UserDefaults.standard }
    
    init?(inMemoryStorage: Bool = false, userDefaults: UserDefaults = UserDefaults.standard, completed: (() -> Void)? = nil) {
        self.userDefaults = userDefaults
        persitence = PersistenceController(inMemory: inMemoryStorage, loaded: { [weak self] in
            // TODO Fix. Not correct..
            DispatchQueue.main.async {
                if !userDefaults.bool(forKey: UserDefaults.StorageKeys.isStoragePopulated.rawValue) {
                    self?.populateStorage()
                    userDefaults.set(true, forKey: UserDefaults.StorageKeys.isStoragePopulated.rawValue)
                }
                if let self = self { self.setup(persistence: self.persitence) }
                
                completed?()
            }
        })
    }
    
    func populateStorage() {
        let context = self.persitence.container.viewContext
        
        Loader.populate(context, file: "Fruits")
        Loader.populate(context, file: "Vegetables")
        Loader.populate(context, file: "Meat")
        Loader.populate(context, file: "Seafood")
        Loader.populate(context, file: "Dairy")
        Loader.populate(context, file: "Pantry")
    }
    
    func setup(persistence: PersistenceController) {
        let user = UserController(persistenceController: persistence)
        self.consumedStorage = ConsumedStorageController(persistenceController: persistence, userController: user)
        self.foodStorage = FoodStorageController(persistenceController: persistence, userController: user)
        self.mealStorage = MealStorageController(persistenceController: persistence, userController: user)
        self.user = user
        
        self.isContentLoaded = true
    }        
}

extension UserDefaults {
    enum StorageKeys: String {
        case isStoragePopulated
    }
}
