//
//  FoodControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-27.
//

import XCTest

@testable import Nutrition

class FoodControllerTests: XCTestCase {
    var persistance: PersistenceController!
    var profileController: NutritionProfileController!
    var foodController: FoodController!
    
    override func setUpWithError() throws {
        persistance = PersistenceController(inMemory: true)
        let food = CDFood(context: persistance.container.viewContext, name: "Apple", category: 0,
                          nutritionProfile: CDNutritionProfile(context: persistance.container.viewContext, food: nil))
        foodController = FoodController(food: food, required: NewNutritionProfile(nutrients: []), persistenceController: persistance)
    }

    func test_foodController_eat() throws {
        // Given
        let amount: Int16 = 125
        let expectation = self.expectation(description: "Eat food")
        
        // When
        foodController.eat(amount: amount) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let consumed = try XCTUnwrap(CDConsumed.latest(context: persistance.container.viewContext).first)
        let eatable = try XCTUnwrap(consumed.eatable)
        XCTAssertEqual(eatable.amount, amount)
        XCTAssertEqual(eatable.food.id, foodController.food.id)
    }
}
