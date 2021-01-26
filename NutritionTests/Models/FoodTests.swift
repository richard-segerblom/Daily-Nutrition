//
//  FoodTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class FoodTests: XCTestCase {
    var persistent: PersistenceController!
    var apple: CDFood!
    var orange: CDFood!
    
    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
        
        apple = CDFood(context: persistent.container.viewContext, name: "Apple", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))
        orange = CDFood(context: persistent.container.viewContext, name: "Orange", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))          
    }

    func test_food_all() {
        // When
        let food = CDFood.all(context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(food.count, 2)
    }
    
    func test_food_withID() {
        // Given
        let foodID =  orange.foodID
        
        // When
        let food = CDFood.withID(foodID, context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(food?.foodID, foodID)        
    }

}
