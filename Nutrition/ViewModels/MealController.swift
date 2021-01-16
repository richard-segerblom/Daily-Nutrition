//
//  MealController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import Foundation

final class MealController: Identifiable {
    let nutritionProfile: NutritionProfileController
    let persistenceController: PersistenceController
    
    let meal: Meal
    var required: NutritionProfile
    
    var id: UUID { meal.id }
    var name: String { meal.name }
    var ingredients: [Ingredient] { meal.ingredients }
    var caloriesText: String { String("\(nutritionProfile[.calories].intValue)") + " kcal" }
    var category: MealCategory { meal.category }
    
    init(meal: Meal, required: NutritionProfile, persistenceController: PersistenceController) {
        self.meal = meal
        self.required = required
        self.persistenceController = persistenceController
        self.nutritionProfile = NutritionProfileController(profile: meal.makeNutritionProfile(), required: required)
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
