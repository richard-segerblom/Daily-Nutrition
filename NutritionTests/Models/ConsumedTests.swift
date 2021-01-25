//
//  ConsumedTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class ConsumedTests: XCTestCase {
    var persistent: PersistenceController!
    var smoothie: CDMeal!
    var pancakes: CDMeal!
    var apple: CDFood!
    var eatable: CDEatable!
    var consumedSmoothie: CDConsumed!
    var consumedPancakes: CDConsumed!
    var consumedApple: CDConsumed!
    
    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
        
        apple = CDFood(context: persistent.container.viewContext, name: "Apple", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))
        
        eatable = CDEatable(context: persistent.container.viewContext, amount: 80, food: apple)
        
        smoothie = CDMeal(context: persistent.container.viewContext, name: "Smoothie", mealCategory: .breakfast)
        pancakes = CDMeal(context: persistent.container.viewContext, name: "Pancakes", mealCategory: .lunch)
        
        consumedSmoothie = CDConsumed(context: persistent.container.viewContext, meal: smoothie, eatable: nil)
        consumedPancakes = CDConsumed(context: persistent.container.viewContext, meal: pancakes, eatable: nil, date: Date(timeIntervalSince1970: 0))
        consumedApple = CDConsumed(context: persistent.container.viewContext, meal: nil, eatable: eatable)
    }

    override func tearDownWithError() throws {
        persistent = nil
        apple = nil
        eatable = nil
        smoothie = nil
        pancakes = nil
        consumedSmoothie = nil
        consumedPancakes = nil
        consumedApple = nil
    }

    func test_consumed_today() {
        // When
        let today = CDConsumed.today(context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(today.count, 2)
        XCTAssertTrue(today.contains { $0.consumedID == consumedSmoothie.consumedID })
        XCTAssertTrue(today.contains { $0.consumedID == consumedApple.consumedID })
    }
    
    func test_consumed_latestMeals() {
        // When
        let meals = CDConsumed.latestMeals(context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(meals.count, 2)
        XCTAssertTrue(meals.contains { $0.consumedID == consumedSmoothie.consumedID })
        XCTAssertTrue(meals.contains { $0.consumedID == consumedPancakes.consumedID })
    }
    
    func test_consumed_latest() {
        // When
        let latest = CDConsumed.latest(context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(latest.count, 3)
        XCTAssertTrue(latest.contains { $0.consumedID == consumedSmoothie.consumedID })
        XCTAssertTrue(latest.contains { $0.consumedID == consumedPancakes.consumedID })
        XCTAssertTrue(latest.contains { $0.consumedID == consumedApple.consumedID })
    }
}
