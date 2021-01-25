//
//  ReferenceDailyIntakeTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-22.
//

import XCTest

@testable import Nutrition

class ReferenceDailyIntakeTests: XCTestCase {
    var man25Year: NutritionProfile!
    var woman48Year: NutritionProfile!
    
    override func setUpWithError() throws {
        man25Year = NewNutritionProfile(nutrients: [
            NewNutrient(key: .la, value: 17, unit: .g),
            NewNutrient(key: .ala, value: 1.6, unit: .g),
            NewNutrient(key: .calories, value: 2400, unit: .kcal),
            NewNutrient(key: .calcium, value: 1000, unit: .mg),
            NewNutrient(key: .iron, value: 8, unit: .mg),
            NewNutrient(key: .magnesium, value: 400, unit: .mg),
            NewNutrient(key: .phosphorus, value: 700, unit: .mg),
            NewNutrient(key: .potassium, value: 3400, unit: .mg),
            NewNutrient(key: .sodium, value: 2300, unit: .mg),
            NewNutrient(key: .zinc, value: 11, unit: .mg),
            NewNutrient(key: .copper, value: 900, unit: .mcg),
            NewNutrient(key: .manganese, value: 2.3, unit: .mg),
            NewNutrient(key: .selenium, value: 55, unit: .mcg),
            NewNutrient(key: .a, value: 900, unit: .mcg),
            NewNutrient(key: .e, value: 15, unit: .mg),
            NewNutrient(key: .c, value: 90, unit: .mg),
            NewNutrient(key: .b1, value: 1.2, unit: .mg),
            NewNutrient(key: .b2, value: 1.3, unit: .mg),
            NewNutrient(key: .b3, value: 16, unit: .mg),
            NewNutrient(key: .b6, value: 1.3, unit: .mg),
            NewNutrient(key: .b12, value: 2.4, unit: .mcg),
            NewNutrient(key: .choline, value: 550, unit: .mg),
            NewNutrient(key: .k, value: 120, unit: .mcg),
            NewNutrient(key: .b9, value: 400, unit: .mcg)
        ])
        
        woman48Year = NewNutritionProfile(nutrients: [
            NewNutrient(key: .la, value: 12, unit: .g),
            NewNutrient(key: .ala, value: 1.1, unit: .g),
            NewNutrient(key: .calories, value: 1800, unit: .kcal),
            NewNutrient(key: .calcium, value: 1000, unit: .mg),
            NewNutrient(key: .iron, value: 18, unit: .mg),
            NewNutrient(key: .magnesium, value: 320, unit: .mg),
            NewNutrient(key: .phosphorus, value: 700, unit: .mg),
            NewNutrient(key: .potassium, value: 2600, unit: .mg),
            NewNutrient(key: .sodium, value: 2300, unit: .mg),
            NewNutrient(key: .zinc, value: 8, unit: .mg),
            NewNutrient(key: .copper, value: 900, unit: .mcg),
            NewNutrient(key: .manganese, value: 1.8, unit: .mg),
            NewNutrient(key: .selenium, value: 55, unit: .mcg),
            NewNutrient(key: .a, value: 700, unit: .mcg),
            NewNutrient(key: .e, value: 15, unit: .mg),
            NewNutrient(key: .c, value: 75, unit: .mg),
            NewNutrient(key: .b1, value: 1.1, unit: .mg),
            NewNutrient(key: .b2, value: 1.1, unit: .mg),
            NewNutrient(key: .b3, value: 14, unit: .mg),
            NewNutrient(key: .b6, value: 1.3, unit: .mg),
            NewNutrient(key: .b12, value: 2.4, unit: .mcg),
            NewNutrient(key: .choline, value: 425, unit: .mg),
            NewNutrient(key: .k, value: 90, unit: .mcg),
            NewNutrient(key: .b9, value: 400, unit: .mcg)
        ])
    }

    override func tearDownWithError() throws {
        man25Year = nil
        woman48Year = nil
    }

    func test_referenceDailyIntake_withMan25Year() {
        // Given
        let gender = Gender.man
        let age = 25
        
        // When
        let profile = ReferenceDailyIntake.nutritionProfile(gender: gender, age: age)
        
        // Then
        for (key, nutrient) in man25Year.nutrients {
            let profileNutrient = profile.nutrients[key]
            
            XCTAssertEqual(profileNutrient?.key, nutrient.key)
            XCTAssertEqual(profileNutrient?.value, nutrient.value)
            XCTAssertEqual(profileNutrient?.unit, nutrient.unit)
        }
    }
    
    func test_referenceDailyIntake_withWoman48Year() {
        // Given
        let gender = Gender.woman
        let age = 48
        
        // When
        let profile = ReferenceDailyIntake.nutritionProfile(gender: gender, age: age)
        
        // Then
        for (key, nutrient) in woman48Year.nutrients {
            let profileNutrient = profile.nutrients[key]
            
            XCTAssertEqual(profileNutrient?.key, nutrient.key)
            XCTAssertEqual(profileNutrient?.value, nutrient.value)
            XCTAssertEqual(profileNutrient?.unit, nutrient.unit)
        }
    }        
}
