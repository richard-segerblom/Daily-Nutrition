//
//  MealControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-27.
//

import XCTest

@testable import Nutrition

class MealControllerTests: XCTestCase {
    var persistance: PersistenceController!
    var mealController: MealController!

    override func setUpWithError() throws {
        persistance = PersistenceController(inMemory: true)
        let meal = CDMeal(context: persistance.container.viewContext, name: "Smoothie", mealCategory: .breakfast)
        let required = CDNutritionProfile(context: persistance.container.viewContext, food: nil)
        mealController = MealController(meal: meal, required: required, persistenceController: persistance)
    }

    func test_mealController_eat() throws {
        let expectation = self.expectation(description: "Eat meal")
        
        // When
        mealController.eat() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let consumed = try XCTUnwrap(CDConsumed.latest(context: persistance.container.viewContext).first)
        let meal = try XCTUnwrap(consumed.meal)
        XCTAssertEqual(meal.id, mealController.meal.id)
    }
    
    func test_mealController_delete() {
        let expectation = self.expectation(description: "Eat meal")
        
        // When
        mealController.delete() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let meals = CDMeal.all(context: persistance.container.viewContext)
        XCTAssertTrue(meals.isEmpty)
    }
}
