//
//  NutrientContollerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-27.
//

import XCTest

@testable import Nutrition

class NutrientContollerTests: XCTestCase {

    func test_nutrientController_progress_withNoReuired() {
        // Given
        let nutrient = NewNutrient(key: .b12, value: 5, unit: .mg)
        let nutrientController = NutrientController(nutrient: nutrient, required: nil)
        
        // When
        let progress = nutrientController.progress
        
        // Then
        XCTAssertEqual(progress, 0.0)
    }
    
    func test_nutrientController_progress_withZeroReuired() {
        // Given
        let nutrient = NewNutrient(key: .b12, value: 5, unit: .mg)
        let required = NewNutrient(key: .b12, value: 0, unit: .mg)
        let nutrientController = NutrientController(nutrient: nutrient, required: required)
        
        // When
        let progress = nutrientController.progress
        
        // Then
        XCTAssertEqual(progress, 0.0)
    }
    
    func test_nutrientController_progress_withReuiredValueLessThenOnePercent() {
        // Given
        let nutrient = NewNutrient(key: .b12, value: 0.01, unit: .mg)
        let required = NewNutrient(key: .b12, value: 5, unit: .mg)
        let nutrientController = NutrientController(nutrient: nutrient, required: required)
        
        // When
        let progress = nutrientController.progress
        
        // Then
        XCTAssertEqual(progress, 0.0)
    }
    
    func test_nutrientController_progress_withReuired() {
        // Given
        let nutrient = NewNutrient(key: .b12, value: 2, unit: .mg)
        let required = NewNutrient(key: .b12, value: 5, unit: .mg)
        let nutrientController = NutrientController(nutrient: nutrient, required: required)
        
        // When
        let progress = nutrientController.progress
        
        // Then
        XCTAssertEqual(progress, 0.4)
    }
}
