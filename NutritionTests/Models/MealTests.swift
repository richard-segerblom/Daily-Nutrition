//
//  MealTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class MealTests: XCTestCase {
    var persistent: PersistenceController!
    var smoothie: CDMeal!
    var pancakes: CDMeal!

    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
        
        smoothie = CDMeal(context: persistent.container.viewContext, name: "Smoothie", mealCategory: .breakfast)
        pancakes = CDMeal(context: persistent.container.viewContext, name: "Pancakes", mealCategory: .lunch)                
    }

    override func tearDownWithError() throws {
        persistent = nil
        smoothie = nil
        pancakes = nil
    }

    func test_meal_all() {
        // When
        let meals = CDMeal.all(context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(meals.count, 2)
    }
    
    func test_meal_withID() {
        // Given
        let mealID = pancakes.mealID
        
        // When
        let meal = CDMeal.withID(mealID, context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(meal?.mealID, mealID)
    }
}
