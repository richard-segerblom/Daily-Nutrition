//
//  NutritionProfileControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-27.
//

import XCTest

@testable import Nutrition

class NutritionProfileControllerTests: XCTestCase {
    var profile: NutritionProfile!
    var required: NutritionProfile!
    var profileController: NutritionProfileController!

    override func setUpWithError() throws {        
        profile = NewNutritionProfile(nutrients: [
            NewNutrient(key: .iron, value: 8, unit: .mg),
            NewNutrient(key: .magnesium, value: 400, unit: .mg),
            NewNutrient(key: .phosphorus, value: 700, unit: .mg),
            NewNutrient(key: .potassium, value: 3400, unit: .mg),
            NewNutrient(key: .c, value: 90, unit: .mg),
            NewNutrient(key: .b3, value: 16, unit: .mg),
            NewNutrient(key: .b12, value: 2.4, unit: .mcg)
        ])
        required = NewNutritionProfile(nutrients: [
            NewNutrient(key: .iron, value: 12, unit: .mg),
            NewNutrient(key: .magnesium, value: 600, unit: .mg),
            NewNutrient(key: .phosphorus, value: 950, unit: .mg),
            NewNutrient(key: .potassium, value: 3600, unit: .mg),
            NewNutrient(key: .c, value: 1100, unit: .mg),
            NewNutrient(key: .b3, value: 54, unit: .mg),
            NewNutrient(key: .b12, value: 7.4, unit: .mcg)
        ])
        profileController = NutritionProfileController(profile: profile, required: required)
    }

    func test_nutritionProfileController_updateRequired() {
        // Given
        let key = NutrientKey.b3
        let value = "75"
            
        // When
        profileController.updateRequired(key: key, value: value)
        
        // Then
        XCTAssertEqual(profileController.required.nutrients[key]?.value, Float(value))
    }

    func test_nutritionProfileController_scale() {
       // Given
        let scaleValue: Float = 0.65
        
        // When
        profileController.scale(scaleValue)
        
        // Then
        for (key, nutrient) in profileController.profile.nutrients {
            XCTAssertEqual(nutrient.value, (profile.nutrients[key]?.value ?? 0) * scaleValue)
        }
    }
    
    func test_nutritionProfileController_subscriptNutrientKey_singleObject() {
        // Given
        let key = NutrientKey.b12
        
        // When
        let nutrientController = profileController[key]
        
        // Then
        XCTAssertEqual(nutrientController.key, key)
    }
    
    func test_nutritionProfileController_subscriptNutrientKey_multipleObjects() {
        // Given
        let keys: [NutrientKey] = [.iron, .potassium, .c, .b12]
        
        // When
        let nutrientControllers: [NutrientController] = profileController[keys]
        
        // Then
        XCTAssertEqual(nutrientControllers.count, 4)
        for key in keys {
            XCTAssertTrue(nutrientControllers.contains { $0.key == key })
        }
    }
}
