//
//  Eatable.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-02.
//

import Foundation

final class ReferenceDailyIntake {
    class func nutritionProfile(gender: Gender, age: Int) -> NutritionProfile {
        let category = ageCategory(age: age)
        let table = gender == .man ? nutrientTableMen : nutrientTableWoman
        
        var all: [Nutrient] = []
        for (key, index) in tableIndexes {
            let value = table[index][category]
            all.append(NewNutrient(key: key, value: value, unit: NutritionProfileController.unit(key)))
        }
        
        let calories = table[tableIndexes[.calories]!][category]
        all.append(NewNutrient(key: .carbs, value: Float(round((calories * 0.5) / 4)), unit: .g))
        all.append(NewNutrient(key: .protein, value: Float(round((calories * 0.25) / 4)), unit: .g))
        all.append(NewNutrient(key: .fats, value: Float(round((calories * 0.25) / 9)), unit: .g))                
        
        return NewNutritionProfile(nutrients: all)
    }
}

extension ReferenceDailyIntake {
    private static let tableIndexes: [NutrientKey: Int] = [
        .la:0, .ala:1, .calories:2, .calcium:3, .iron:4, .magnesium:5, .phosphorus:6, .potassium:7, .sodium:8, .zinc:9, .copper: 10,
        .manganese: 11, .selenium: 12, .a:13, .e:14, .c:15, .b1:16, .b2:17, .b3:18, .b6:19, .b12:20, .choline:21, .k:22, .b9:23]
    
    private class func ageCategory(age: Int) -> Int {
        switch age {
        case 2...3:
            return 0
        case 4...8:
            return 1
        case 9...13:
            return 2
        case 14...18:
            return 3
        case 19...30:
            return 4
        case 31...50:
            return 5
        default:
            return 6
        }
    }        
    
    private static let nutrientTableMen: [[Float]] = [
        [7, 10, 12, 16, 17, 17, 14],                    // LA - g
        [0.7, 0.9, 1.2, 1.6, 1.6, 1.6, 1.6],            // ALA - g
        [1000, 1400, 1800, 2200, 2400, 2200, 2000],     // Calories - kcal
                    
        [700, 1000, 1300, 1300, 1000, 1000, 1000],      // Calcium - mg
        [7, 10, 8, 11, 8, 8, 8],                        // Iron - mg
        [80, 130, 240, 410, 400, 420, 420],             // Magnesium - mg
        [460, 500, 1250, 1250, 700, 700, 700],          // Phosphorus - mg
        [2000, 2300, 2500, 3000, 3400, 3400, 3400],     // Potassium - mg
        [1200, 1500, 1800, 2300, 2300, 2300, 2300],     // Sodium - mg
        [3, 5, 8, 11, 11, 11, 11],                      // Zinc - mg
        [340, 440, 700, 890, 900, 900, 900],            // Copper - mcg
        [1.2, 1.5, 1.9, 2.2, 2.3, 2.3, 2.3],            // Manganese - mg
        [20, 30, 40, 55, 55, 55, 55],                   // Selenium - mcg
        
        [300, 400, 600, 900, 900, 900, 900],            // Vitamin A - mcg
        [6, 7, 11, 15, 15, 15, 15],                     // Vitamin E - mg
        [15, 25, 45, 75, 90, 90, 90],                   // Vitamin C - mg
        [0.5, 0.6, 0.9, 1.2, 1.2, 1.2, 1.2],            // B1 Thiamin - mg
        [0.5, 0.6, 0.9, 1.3, 1.3, 1.3, 1.3],            // B2 Riboflavin  - mg
        [6, 8, 12, 16, 16, 16, 16],                     // B3 Niacin - mg
        [0.5, 0.6, 1.0, 1.3, 1.3, 1.3, 1.7],            // B6 - mg
        [0.9, 1.2, 1.8, 2.4, 2.4, 2.4, 2.4],            // B12 - mcg
        [200, 250, 375, 550, 550, 550, 550],            // Choline - mg
        [30, 55, 60, 75, 120, 120, 120],                // Vitamin K - mcg
        [150, 200, 300, 400, 400, 400, 400]]            // B9 Folate - mcg
                
    private static let nutrientTableWoman: [[Float]] = [
        [7, 10, 10, 11, 12, 12, 11],                    // LA - g
        [0.7, 0.9, 1.0, 1.1, 1.1, 1.1, 1.1],            // ALA - g
        [1000, 1200, 1600, 1800, 2000, 1800, 1600],     // Calories - kcal
                    
        [700, 1000, 1300, 1300, 1000, 1000, 1200],      // Calcium - mg
        [7, 10, 8, 15, 18, 18, 8],                      // Iron - mg
        [80, 130, 240, 360, 310, 320, 320],             // Magnesium - mg
        [460, 500, 1250, 1250, 700, 700, 700],          // Phosphorus - mg
        [2000, 2300, 2300, 2300, 2600, 2600, 2600],     // Potassium - mg
        [1200, 1500, 1800, 2300, 2300, 2300, 2300],     // Sodium - mg
        [3, 5, 8, 9, 8, 8, 8],                          // Zinc - mg
        [340, 440, 700, 890, 900, 900, 900],            // Copper - mcg
        [1.2, 1.5, 1.6, 1.6, 1.8, 1.8, 1.8],            // Manganese - mg
        [20, 30, 40, 55, 55, 55, 55],                   // Selenium - mcg
        
        [300, 400, 600, 700, 700, 700, 700],            // Vitamin A - mcg
        [6, 7, 11, 15, 15, 15, 15],                     // Vitamin E - mg
        [15, 25, 45, 65, 75, 75, 75],                   // Vitamin C - mg
        [0.5, 0.6, 0.9, 1.0, 1.1, 1.1, 1.1],            // B1 Thiamin - mg
        [0.5, 0.6, 0.9, 1.0, 1.1, 1.1, 1.1],            // B2 Riboflavin - mg
        [6, 8, 12, 14, 14, 14, 14],                     // B3 Niacin - mg
        [0.5, 0.6, 1.0, 1.2, 1.3, 1.3, 1.5],            // B6 - mg
        [0.9, 1.2, 1.8, 2.4, 2.4, 2.4, 2.4],            // B12 - mcg
        [200, 250, 375, 400, 425, 425, 425],            // Choline - mg
        [30, 55, 60, 75, 90, 90, 90],                   // Vitamin K - mcg
        [150, 200, 300, 400, 400, 400, 400]]            // B9 Folate - mcg
}
