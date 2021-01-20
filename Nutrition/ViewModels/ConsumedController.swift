//
//  ConsumedController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import Foundation

final class ConsumedController: NutritionProfileController {
    let consumed: Consumed
    let persistenceController: PersistenceController
    
    var foodCategory: FoodCategory? { consumed.eatable?.food.category }
    var mealCategory: MealCategory? { consumed.meal?.category }
    
    var name: String {
        var name = "???"
        if let mealName = consumed.meal?.name {
            name = mealName
        } else if let foodName = consumed.eatable?.food.name, let amount = consumed.eatable?.amount {
            name = "\(amount)g " + foodName
        }
        return name
    }
    
    var date: Date { consumed.date }
    var caloriesText: String { String("\(self[.calories].intValue)") + " kcal" }
    var meal: Meal? { consumed.meal }
    var eatable: Eatable? { consumed.eatable }        
    
    init(consumed: Consumed, required: NutritionProfile, persistenceController: PersistenceController) {
        self.consumed = consumed
        self.persistenceController = persistenceController
        
        super.init(profile: consumed.nutritionProfile, required: required, id: consumed.id)
    }
    
    func eat(completion: (() -> Void)? = nil) {
        let context = persistenceController.container.viewContext
        CDConsumed(context: context, meal: consumed.meal as? CDMeal, eatable: consumed.eatable as? CDEatable)
        
        persistenceController.saveChanges(success: { completion?() })
    }
    
    func delete(completion: (() -> Void)? = nil) {
        persistenceController.container.viewContext.delete(consumed as! CDConsumed)
        persistenceController.saveChanges(success: completion)
    }
}
