//
//  FoodController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-03.
//

import Foundation
import CoreData

final class FoodController: NutritionProfileController {
    let persistenceController: PersistenceController
    let food: Food
    
    var name: String { food.name }
    var category: FoodCategory { food.category }
    var caloriesText: String { "\(intValue(key: .calories)) kcal" }    
    
    init(food: Food, required: NutritionProfile, persistenceController: PersistenceController) {
        self.food = food
        self.persistenceController = persistenceController
        
        super.init(profile: food.profile, required: required)
    }
    
    func eat(amount: Int16, completion: (() -> Void)? = nil) {
        let context = persistenceController.container.viewContext
        let eatable = CDEatable(context: context, amount: amount, food: food as! CDFood)
        CDConsumed(context: context, meal: nil, eatable: eatable)
                
        persistenceController.saveChanges(success: { completion?() })
    }    
}
