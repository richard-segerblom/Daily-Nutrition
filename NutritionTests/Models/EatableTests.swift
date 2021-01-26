//
//  EatableTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class EatableTests: XCTestCase {
    var persistent: PersistenceController!
    var apple: CDFood!
    var orange: CDFood!
    var firstEatable: CDEatable!
    var secondEatable: CDEatable!

    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
        
        apple = CDFood(context: persistent.container.viewContext, name: "Apple", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))
        orange = CDFood(context: persistent.container.viewContext, name: "Orange", category: FoodCategory.fruit.rawValue,
                       nutritionProfile: CDNutritionProfile(context: persistent.container.viewContext, food: nil))
        
        firstEatable = CDEatable(context: persistent.container.viewContext, amount: 75, food: apple)
        secondEatable = CDEatable(context: persistent.container.viewContext, amount: 120, food: orange)
    }

    func test_eatable_withID() throws {
        // Given
        let eatableID = secondEatable.eatableID
        
        // When
        let eatable = CDEatable.withID(eatableID, context: persistent.container.viewContext)
    
        // Then
        XCTAssertEqual(eatable?.eatableID, eatableID)
    }

}
