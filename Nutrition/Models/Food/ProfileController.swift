//
//  ProfileController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-01.
//

import Foundation

enum NutrientCategory {
    case vitamins
    case minerals
    case energy
    case fats
}

final class FoodProfile: Identifiable {
    let id = UUID()    
    let food: Food
    let required: NutritionProfile
    
    var name: String { food.name }
    
    private let profile: NutritionProfile
    private let profileAll: [NutrientKey: Nutrient]
    private let requiredAll: [NutrientKey: Nutrient]
    
    static private let vitaminKeys: [NutrientKey] = [.a, .c, .e, .k, .b1, .b2, .b3, .b6, .b9, .b12, .choline]
    static private let mineralKeys: [NutrientKey] = [.calcium, .phosphorus, .potassium, .manganese, .iron, .zinc, .copper,
                                                     .sodium, .manganese, .selenium]
    static private let energyKeys:  [NutrientKey] = [.carbs, .protein, .fats, .calories]
    static private let fatKeys:     [NutrientKey] = [.saturated, .monounsaturated, .polyunsaturated, .ala, .epa, .dha, .la]
    
    
    init(food: Food, required: NutritionProfile) {
        self.food = food
        self.profile = food.profile
        self.required = required
        self.profileAll = profile.all
        self.requiredAll = required.all
    }
    
    func floatValue(key: NutrientKey) -> Float {
        return self[key].floatValue
    }
    
    func intValue(key: NutrientKey) -> Int {
        return self[key].intValue
    }
//    
//    func progress(_ key: NutrientKey) -> Float {
//        guard let required = required.all[key] else { return 0.0 }
//        guard let current = self[key] else { return 0.0 }
//        
//        if required.value == 0 { return 1.0 }
//        
//        let value = Float(current.value / required.value)
//        if Int(value * 100) == 0 { return 0.0 }
//        
//        return value
//    }
    
//    func keys(_ category: NutrientCategory) -> [NutrientKey] {
//        switch category {
//        case .vitamins:
//            return ProfileController.vitaminKeys
//        case .minerals:
//            return ProfileController.mineralKeys
//        case .energy:
//            return ProfileController.energyKeys
//        case .fats:
//            return ProfileController.fatKeys
//        }
//    }
    
    subscript(key: NutrientKey) -> NutrientController {
        get {
            var nutrient = profileAll[key]
            if nutrient == nil { nutrient = EmptyNutrient(key: key, value: 0, unit: .g) }
            
            let required = requiredAll[key]
            
            return NutrientController(nutrient: nutrient!, required: required)
        }
    }
    
    subscript(keys: [NutrientKey]) -> [NutrientController] {
        get {
            var nutrientControllers: [NutrientController] = []
            for key in keys {
                var nutrient = profileAll[key]
                if nutrient == nil { nutrient = EmptyNutrient(key: key, value: 0, unit: .g) }
                
                let required = requiredAll[key]
                
                nutrientControllers.append(NutrientController(nutrient: nutrient!, required: required))
            }
            
            return nutrientControllers
        }
    }
    
    subscript(category: NutrientCategory) -> [NutrientController] {
        get {
            switch category {
            case .vitamins:
                return nutrients(FoodProfile.vitaminKeys)
            case .minerals:
                return nutrients(FoodProfile.mineralKeys)
            case .energy:
                return nutrients(FoodProfile.energyKeys)
            case .fats:
                return nutrients(FoodProfile.fatKeys)
            }
        }
    }

    static func totalProgress(nutrients: [NutrientController]) -> Float {
        nutrients.map { $0.limitProgress }.reduce(0, +) / Float(nutrients.count) * 100
    }
    
    private func nutrients(_ keys: [NutrientKey]) -> [NutrientController] {
        var nutrients: [NutrientController] = []
        for key in keys {
            if let nutrient = profileAll[key] {
                nutrients.append(NutrientController(nutrient: nutrient, required: requiredAll[key]))
            }
        }
        
        return nutrients
    }
    
    private struct EmptyNutrient: Nutrient {
        var id = UUID()
        var key: NutrientKey
        var value: Float
        var unit: Unit
    }
}
