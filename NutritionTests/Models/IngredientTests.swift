//
//  IngredientTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class IngredientTests: XCTestCase {
    var persistent: PersistenceController!
    var smoothie: CDMeal!
    var pancakes: CDMeal!
    var apple: CDFood!
    var orange: CDFood!
    var ingredientOne: CDIngredient!
    var ingredientTwo: CDIngredient!
    var ingredientThree: CDIngredient!
    
    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
        
        smoothie = CDMeal(context: persistent.container.viewContext, name: "Smoothie", mealCategory: .breakfast)
        pancakes = CDMeal(context: persistent.container.viewContext, name: "Pancakes", mealCategory: .lunch)
        
        apple = CDFood(context: persistent.container.viewContext, name: "Apple", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))
        orange = CDFood(context: persistent.container.viewContext, name: "Orange", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))
        
        ingredientOne = CDIngredient(context: persistent.container.viewContext, amount: 75, sortOrder: 0, food: apple, meal: smoothie)
        ingredientTwo = CDIngredient(context: persistent.container.viewContext, amount: 50, sortOrder: 0, food: orange, meal: smoothie)
        ingredientThree = CDIngredient(context: persistent.container.viewContext, amount: 50, sortOrder: 0, food: apple, meal: pancakes)                
    }

    func test_ingredient_inMeal() {
        // Given
        let mealID = smoothie.mealID
        
        // When
        let ingredients = CDIngredient.inMeal(mealID: mealID, context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(ingredients.count, 2)
        XCTAssertTrue(ingredients.contains { $0.ingredientID == ingredientOne.ingredientID })
        XCTAssertTrue(ingredients.contains { $0.ingredientID == ingredientTwo.ingredientID })
    }
}
