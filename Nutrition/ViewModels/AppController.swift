//
//  AppController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-06.
//

import Foundation

final class AppController: ObservableObject {
    @Published var isContentLoaded = false
    
    let userDefaults: UserDefaults
    
    var persitence: PersistenceController! = nil
    var user: UserController! = nil
    var consumedStorage: ConsumedStorageController! = nil
    var foodStorage: FoodStorageController! = nil
    var mealStorage: MealStorageController! = nil
    
    static private let isDataLoadedKey = "isDataLoaded"
    
    init(persistenceController: PersistenceController, userController: UserController, userDefaults: UserDefaults = UserDefaults.standard) {
        self.user = userController
        self.persitence = persistenceController
        self.userDefaults = userDefaults
                
        self.populateStorage()
        
        consumedStorage = ConsumedStorageController(persistenceController: persitence, userController: userController)
        foodStorage = FoodStorageController(persistenceController: persitence, userController: userController)
        mealStorage = MealStorageController(persistenceController: persitence, userController: userController)
    }
    
    init?(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        persitence = PersistenceController(loaded: { [weak self] in
            // TODO Fix. Not correct..
            DispatchQueue.main.async {
                if !userDefaults.bool(forKey: AppController.isDataLoadedKey) {
                    self?.populateStorage()
                    userDefaults.set(true, forKey: AppController.isDataLoadedKey)
                }
                self?.setup()
            }
        })
    }
    
    private func populateStorage() {
        let context = self.persitence.container.viewContext
        
        Loader.populate(context, file: "Fruits")
        Loader.populate(context, file: "Vegetables")
        Loader.populate(context, file: "Meat")
        Loader.populate(context, file: "Seafood")
        Loader.populate(context, file: "Dairy")
        Loader.populate(context, file: "Pantry")
    }
    
    private func setup() {
        let user = UserController(persistenceController: PersistenceController.shared)
        self.consumedStorage = ConsumedStorageController(persistenceController: PersistenceController.shared, userController: user)
        self.foodStorage = FoodStorageController(persistenceController: PersistenceController.shared, userController: user)
        self.mealStorage = MealStorageController(persistenceController: PersistenceController.shared, userController: user)
        self.user = user
        
        self.isContentLoaded = true
    }        
}
