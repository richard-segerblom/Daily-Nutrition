//
//  NutreintTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class NutrientTests: XCTestCase {
    var persistent: PersistenceController!
    var profile: CDNutritionProfile!
    var nutrient: CDNutrient!
    let nutrientValue: Float = 1.52

    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
       
        profile = CDNutritionProfile(context: persistent.container.viewContext, food: nil)
        nutrient = CDNutrient(context: persistent.container.viewContext, key: NutrientKey.b12.rawValue, unit: Unit.mg.rawValue,
                   value: nutrientValue, nutritionProfile: profile, nutrientID: profile.nutritionProfileID)
    }
    
    func test_nutrient_withID() {
        // Given
        let nutrientID = nutrient.nutrientID
        
        // When
        let nutrient = CDNutrient.withID(nutrientID, context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(nutrient?.nutrientID, nutrientID)        
    }
    
    func test_nutrient_withProfileID() {
        // Given
        let profileID = profile.nutritionProfileID
        
        // When
        let nutrients = CDNutrient.withProfileID(profileID, context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(nutrients.count, 1)
    }
    
    func test_nutrient_update() {
        // Given
        let nutrientID = nutrient.nutrientID
        let value: Float = 2.11

        // When
        CDNutrient.update(nutrientID: nutrientID, value: value, context: persistent.container.viewContext)

        // Then
        let updatedNutrient = CDNutrient.withID(nutrientID, context: persistent.container.viewContext)
        XCTAssertEqual(updatedNutrient?.value, value)
    }

}
