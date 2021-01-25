//
//  NutritionProfileTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-25.
//

import XCTest

@testable import Nutrition

class NutritionProfileTests: XCTestCase {
    var persistent: PersistenceController!
    var firstProfile: NutritionProfile!
    var secondProfile: NutritionProfile!

    override func setUpWithError() throws {
        persistent = PersistenceController(inMemory: true)
        
        firstProfile = NewNutritionProfile(nutrients: [
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
        
        secondProfile = NewNutritionProfile(nutrients: [
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
        persistent = nil
        firstProfile = nil
        secondProfile = nil
    }

    func test_nutritionProfile_scale() {
        // Given
        let scale: Float = 1.3
        
        // When
        let scaledProfile = firstProfile.scale(scale)
        
        // Then
        for (key, nutrient) in scaledProfile.nutrients {
            XCTAssertEqual(nutrient.value, (firstProfile.nutrients[key]?.value ?? 0) * scale)
        }
    }
    
    func test_nutritionProfile_merged() {
        // When
        let mergedProfile = firstProfile.merged(other: secondProfile)
        
        // Then
        for (key, nutrient) in mergedProfile.nutrients {
            XCTAssertEqual(nutrient.value, (firstProfile.nutrients[key]?.value ?? 0) + (secondProfile.nutrients[key]?.value ?? 0))
        }
    }
    
    func test_nutritonProfile_add() {
        // When
        let addedProfile = CDNutritionProfile.add(profile: firstProfile, context: persistent.container.viewContext)
        
        // Then
        XCTAssertNotNil(addedProfile)
    }
    
    func test_nutritionProfile_withID() {
        // Given
        let profile = CDNutritionProfile.add(profile: firstProfile, context: persistent.container.viewContext)
                
        // When
        let fetchedProfile = CDNutritionProfile.withID(profile.id, context: persistent.container.viewContext)
        
        // Then
        XCTAssertEqual(fetchedProfile?.nutritionProfileID, profile.id)
    }

}
