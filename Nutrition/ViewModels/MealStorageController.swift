//
//  MealStorageController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-03.
//

import Foundation
import Combine
import CoreData

final class MealStorageController: ObservableObject {
    @Published var meals: [MealController] = []
    private var recent: [MealController] = []
    
    var isRecentEmpty: Bool { recent.isEmpty }
    
    let persistenceController: PersistenceController
    let userController: UserController
    
    private var _filter: MealFilterOption = .all
    var filter: MealFilterOption = .all {
        willSet {
            filter(newValue)
        }
    }
    
    private var allMeals: [MealController] = []
    private var cancellable: AnyCancellable?
    
    init(persistenceController: PersistenceController, userController: UserController) {
        self.persistenceController = persistenceController
        self.userController = userController
        
        self.fetchMeals()
        self.fetchRecent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeNotification(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        cancellable = self.userController.$user.sink { newUser in
            guard let user = newUser else { return }
            self.allMeals.forEach { $0.required = user.nutritionProfile }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func onChangeNotification(_ notification: Notification) {
        var reloadMeals = false, reloadRecent = false
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            reloadMeals = !insertedObjects.filter { $0 is CDMeal }.isEmpty
            reloadRecent = !insertedObjects.filter { $0 is CDConsumed }.isEmpty
        }
    
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            reloadMeals = !deletedObjects.filter { $0 is CDMeal }.isEmpty
            reloadRecent = reloadMeals
        }
        
        if reloadMeals { fetchMeals() }
        if reloadRecent {fetchRecent() }
    }
    
    func deleteMeal(atOffsets offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
    }
    
    func createMeal(name: String, category: Int, ingredients: [Ingredient]) {
        guard let category = FoodCategory(rawValue: Int16(category)) else { return }
        
        let meal = CDMeal(context: persistenceController.container.viewContext, name: name, foodCategory: category)
        for ingrediet in ingredients {
            CDIngredient(context: persistenceController.container.viewContext, amount: ingrediet.amount, sortOrder: ingrediet.sortOrder, food: ingrediet.food as! CDFood, meal: meal)
        }
        
        persistenceController.saveChanges()
    }
    
    func fetchMeals() {
        self.allMeals = CDMeal.all(context: persistenceController.container.viewContext).map {
            MealController(meal: $0, required: userController.profile, persistenceController: persistenceController)
        }
                 
        self.filter(.all)
    }
    
    func fetchRecent() {
        var distinct: [UUID: Meal] = [:]
        CDConsumed.latestMeals(context: persistenceController.container.viewContext).forEach {
            if let meal = $0.cdMeal {
                if distinct[meal.mealID] == nil {
                    distinct[meal.mealID] = meal
                }
            }
        }
        
        recent = distinct.map { MealController(meal: $1, required: userController.profile, persistenceController: persistenceController) }        
    }
    
    func filter(_ filter: MealFilterOption) {
        _filter = filter
        
        switch filter {
        case .recent:
            meals = recent
        case .breakfast:
            meals = allMeals.filter { $0.category == .breakfast }
        case .lunch:
            meals = allMeals.filter { $0.category == .lunch }
        case .dinner:
            meals = allMeals.filter { $0.category == .dinner }
        case .snack:
            meals = allMeals.filter { $0.category == .snack }
        default:
            meals = allMeals
        }
    }
    
    func description(_ filter: MealFilterOption) -> String {
        switch filter {
        case .recent:
            return "Meals you have eaten will be shown here"
        case .breakfast:
            return "You have no breakfast meals.\nDo you want to create one?"
        case .lunch:
            return "You have no lunch meals.\nDo you want to create one?"
        case .dinner:
            return "You have no dinner meals.\nDo you want to create one?"
        case .snack:
            return "You have no snacks.\nDo you want to create one?"
        default:
            return "You have no meals.\nDo you want to create one?"
        }
    }
}

enum MealFilterOption {
    case all
    case recent
    case breakfast
    case lunch
    case dinner
    case snack
}
