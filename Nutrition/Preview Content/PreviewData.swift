//
//  PreviewData.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-11.
//

import Foundation

struct PreviewData {
    static var nutrients: [Nutrient] =
        [NewNutrient(key: .a, value: 900, unit: .mcg),
         NewNutrient(key: .c, value: 75, unit: .mg),
         NewNutrient(key: .e, value: 10, unit: .mg),
         NewNutrient(key: .b1, value: 1.3, unit: .mg),
         NewNutrient(key: .b2, value: 1.5, unit: .mg),
         NewNutrient(key: .b3, value: 18, unit: .mg),
         NewNutrient(key: .b6, value: 1.5, unit: .mg),
         NewNutrient(key: .b9, value: 300, unit: .mcg),
         NewNutrient(key: .b12, value: 1.3, unit: .mcg),
         NewNutrient(key: .k, value: 120, unit: .mcg),
         NewNutrient(key: .choline, value: 550, unit: .mg),
         
         NewNutrient(key: .k, value: 800, unit: .mg),
         NewNutrient(key: .phosphorus, value: 600, unit: .mg),
         NewNutrient(key: .potassium, value: 3500, unit: .mg),
         NewNutrient(key: .magnesium, value: 350, unit: .mg),
         NewNutrient(key: .iron, value: 9, unit: .mg),
         NewNutrient(key: .zinc, value: 9, unit: .mg),
         NewNutrient(key: .copper, value: 900, unit: .mcg),
         NewNutrient(key: .sodium, value: 2300, unit: .mg),
         NewNutrient(key: .manganese, value: 2.3, unit: .mg),
         NewNutrient(key: .selenium, value: 55, unit: .mcg),
        
         NewNutrient(key: .carbs, value: 325, unit: .g),
         NewNutrient(key: .sugar, value: 0, unit: .g),
         NewNutrient(key: .fiber, value: 0, unit: .g),
         NewNutrient(key: .protein, value: 130, unit: .g),
         NewNutrient(key: .fats, value: 87, unit: .g),
         NewNutrient(key: .calories, value: 2600, unit: .kcal),
            
         NewNutrient(key: .saturated, value: 0, unit: .g),
         NewNutrient(key: .monounsaturated, value: 0, unit: .g),
         NewNutrient(key: .polyunsaturated, value: 0, unit: .g),
         NewNutrient(key: .ala, value: 1.2, unit: .g),
         NewNutrient(key: .la, value: 1.5, unit: .g)]
        
    static var apple: Food { NewFood(id: UUID(), name: "Apple", category: .fruit, profile: appleProfile) }
    static var appleProfile: NutritionProfile {
        let all = nutrients
        var appleNutrients: [Nutrient] = []
        for index in 0..<all.count {
            let nutrient = all[index]
            let randomizedValue = nutrient.value * Float.random(in: 0...1)
            let randomizedNutrient = NewNutrient(key: nutrient.key, value: randomizedValue, unit: nutrient.unit)
            appleNutrients.append(randomizedNutrient)
        }
        return NewNutritionProfile(nutrients: appleNutrients)
    }
    
    static var userProfile = NewNutritionProfile(nutrients: nutrients)
    static var user = User(age: 36, gender: .man, nutritionProfile: userProfile)
    static var userController = UserController(persistenceController: PersistenceController.preview, user: user)
    
    static var profileController = NutritionProfileController(profile: appleProfile, required: userProfile)

    static var nutrientController = NutrientController(nutrient: nutrients[26], required: userProfile.nutrients[.calories])

    static var foodController: FoodController {
        FoodController(food: apple, required: userProfile, persistenceController: PersistenceController.shared)
    }
    
    static var mealController: MealController = {
        let ingredients: [Ingredient] = [NewIngredient(id: UUID(), amount: 75, sortOrder: 0, food: apple, nutritionProfile: appleProfile)]
        let meal = NewMeal(id: UUID(), name: "Smoothie", date: Date(), ingredients: ingredients)
        return MealController(meal: meal, required: userProfile, persistenceController: PersistenceController.preview)
    }()
    
    static var consumedController: ConsumedController = {
        let eatable = NewEatable(id: UUID(), food: apple, amount: 125, nutritionProfile: appleProfile)
        let consumed = NewConsumed(id: UUID(), date: Date(), eatable: eatable, meal: nil, nutritionProfile: appleProfile)
        return ConsumedController(consumed: consumed, required: userProfile)
    }()
    
    static let consumedStorage = ConsumedStorageController(persistenceController: PersistenceController.preview,
                                                           userController: PreviewData.userController)
    
    static let foodStorage = FoodStorageController(persistenceController: PersistenceController.preview,
                                                   userController: PreviewData.userController)
    
    static let mealStorage = MealStorageController(persistenceController: PersistenceController.preview,
                                                   userController: PreviewData.userController)
    
    static let appController = AppController(persistenceController: PersistenceController.preview, userController: userController)
}
