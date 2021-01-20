//
//  MealController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import Foundation

final class MealController: NutritionProfileController {
    let persistenceController: PersistenceController
    var meal: Meal
    
    var name: String { meal.name }
    var ingredients: [Ingredient] { meal.ingredients }
    var caloriesText: String { String("\(self[.calories].intValue)") + " kcal" }
    var category: MealCategory { meal.category }
    
    init(meal: Meal, required: NutritionProfile, persistenceController: PersistenceController) {
        self.meal = meal
        self.persistenceController = persistenceController
        
        super.init(profile: self.meal.nutritionProfile, required: required, id: meal.id)
    }
    
    func ingredientFriendlyName(_ ingredient: Ingredient) -> String {
        "\(ingredient.amount)g   \t\(ingredient.food.name)"
    }
    
    func eat(completion: (() -> Void)? = nil) {
        let context = persistenceController.container.viewContext
        CDConsumed(context: context, meal: meal as? CDMeal, eatable: nil)

        persistenceController.saveChanges(success: { completion?() })
    }
}
