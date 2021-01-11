//
//  SearchResult.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import Foundation

struct SearchResult: Decodable {
    let foods: [USDAFood]
}

struct USDAFood: Decodable, Food {
    var id: UUID = UUID()
    var category: FoodCategory { .fruit }
    var profile: NutritionProfile
    
    let name: String
    var nutrients: [USDANutrient]
    
    enum CodingKeys: String, CodingKey {
        case id = "fdcId"
        case name = "lowercaseDescription"
        case nutrients = "foodNutrients"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nutrients = try container.decode([USDANutrient].self, forKey: .nutrients)
        name = try container.decode(String.self, forKey: .name)
        
        profile = NewNutritionProfile(nutrients: nutrients)
    }
}

struct USDANutrient: Decodable, Nutrient {
    var id = UUID()
    var key: NutrientKey
    var unit: Unit
    var value: Float
    
    enum CodingKeys: String, CodingKey {
        case id = "nutrientId"
        case unit = "unitName"
        case value
    }
    
    let units: [String: Unit] = ["G": .g, "MG": .mg, "IU": .mcg, "UG": .mcg, "KCAL": .kcal]
    let nutrientIDs: [Int: NutrientKey] = [1106: .a, 1162: .c, 1109: .e, 1185: .k, 1165: .b1, 1166: .b2, 1167: .b3, 1175: .b6,
                                           1177: .b9, 1178: .b12, 1180: .choline, 1087: .calcium, 1091: .phosphorus, 1092: .potassium,
                                           1090: .magnesium, 1089: .iron, 1095: .zinc, 1098: .copper, 1093: .sodium, 1101: .manganese,
                                           1103: .selenium, 1005: .carbs, 2000: .sugar, 1079: .fiber, 1003: .protein, 1004: .fats,
                                           1008: .calories, 1258: .saturated, 1292: .monounsaturated, 1293: .polyunsaturated,
                                           1270: .ala, 1269: .la]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
         
        key = nutrientIDs[try container.decode(Int.self, forKey: .id)] ?? .unknown
        value = try container.decode(Float.self, forKey: .value)
        unit = units[try container.decode(String.self, forKey: .unit)] ?? .unknown
    }
}
