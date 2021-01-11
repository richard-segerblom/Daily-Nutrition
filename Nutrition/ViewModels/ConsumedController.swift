//
//  ConsumedController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import Foundation

final class ConsumedController: ObservableObject, Identifiable {
    let consumed: Consumed
    var required: NutritionProfile
    
    var id: UUID { consumed.id }
    var nutritionProfile: NutritionProfileController
    
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
    var caloriesText: String { String("\(nutritionProfile[.calories].intValue)") + " kcal" }
    var meal: Meal? { consumed.meal }
    var eatable: Eatable? { consumed.eatable }        
    
    init(consumed: Consumed, required: NutritionProfile) {
        self.consumed = consumed
        self.required = required
        self.nutritionProfile = NutritionProfileController(profile: consumed.nutritionProfile, required: required)
    }
}
