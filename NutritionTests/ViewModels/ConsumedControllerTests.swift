//
//  ConsumedControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-27.
//

import XCTest

@testable import Nutrition

class ConsumedControllerTests: XCTestCase {
    var persistance: PersistenceController!
    var consumedController: ConsumedController!

    override func setUpWithError() throws {
        persistance = PersistenceController(inMemory: true)
        let meal = CDMeal(context: persistance.container.viewContext, name: "Smoothie", mealCategory: .breakfast)
        let consumed = CDConsumed(context: persistance.container.viewContext, meal: meal, eatable: nil)
        let required = CDNutritionProfile(context: persistance.container.viewContext, food: nil)
        consumedController = ConsumedController(consumed: consumed, required: required, persistenceController: persistance)
    }

    func test_consumedController_eat() {
        let expectation = self.expectation(description: "Eat consumed")
        
        // When
        consumedController.eat() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let allConsumed = CDConsumed.latest(context: persistance.container.viewContext)
        XCTAssertEqual(allConsumed.count, 2)
        for consumed in allConsumed {
            XCTAssertEqual(consumed.meal?.id, consumedController.meal?.id)
        }
    }
    
    func test_consumedController_delete() {
        let expectation = self.expectation(description: "Eat consumed")
        
        // When
        consumedController.delete() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let allConsumed = CDConsumed.latest(context: persistance.container.viewContext)
        XCTAssertTrue(allConsumed.isEmpty)
    }

}
