//
//  MealController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import Foundation

final class MealController: ObservableObject, Identifiable {
    @Published var nutritionProfile: NutritionProfileController
    
    let meal: Meal
    var required: NutritionProfile
    
    var id: UUID { meal.id }
    var name: String { meal.name }
    var ingredients: [Ingredient] { meal.ingredients }
    var caloriesText: String { String("\(nutritionProfile[.calories].intValue)") + " kcal" }
    
    func ingredientFriendlyName(_ ingredient: Ingredient) -> String {
        "\(ingredient.amount)g\t\(ingredient.food.name)"
    }
    
    init(meal: Meal, required: NutritionProfile) {
        self.meal = meal
        self.required = required
        self.nutritionProfile = NutritionProfileController(profile: meal.makeNutritionProfile(), required: required)
    }
}
