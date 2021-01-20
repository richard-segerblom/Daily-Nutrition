//
//  NutritionProfileController.swift
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

class NutritionProfileController: Identifiable, ObservableObject {
    var id: UUID
    var required: NutritionProfile
    
    private let _profile: NutritionProfile
    var scalableProfile: NutritionProfile
    var profile: NutritionProfile { scalableProfile }
        
    static let vitaminKeys: [NutrientKey] = [.a, .c, .e, .k, .b1, .b2, .b3, .b6, .b9, .b12, .choline]
    static let mineralKeys: [NutrientKey] = [.calcium, .phosphorus, .potassium, .magnesium, .iron, .zinc, .copper,
                                                     .sodium, .manganese, .selenium]
    static let energyKeys:  [NutrientKey] = [.carbs, .protein, .fats, .calories]
    static let fatKeys:     [NutrientKey] = [.saturated, .monounsaturated, .polyunsaturated, .ala, .la]
    
    static let nutrientUnits: [NutrientKey: Unit] = [.la:.g, .ala:.g, .calories:.kcal, .calcium:.mg, .iron:.mg, .magnesium:.mg,
                                                     .phosphorus:.mg, .potassium:.mg, .sodium:.mg, .zinc:.mg, .copper:.mcg,
                                                     .manganese:.mg, .selenium:.mcg, .a:.mcg, .e:.mg, .c:.mg, .b1:.mg, .b2:.mg,
                                                     .b3:.mg, .b6:.mg, .b12:.mcg, .choline:.mg, .k:.mcg, .b9:.mcg]
       
    init(profile: NutritionProfile, required: NutritionProfile, id: UUID = UUID()) {
        self._profile = profile
        self.required = required
        self.id = id
        
        scalableProfile = NewNutritionProfile(nutrients: profile.nutrients.map { NewNutrient(id: $1.id, key: $0, value: $1.value, unit: $1.unit) }, id: required.id)
    }
    
    func updateRequired(key: NutrientKey, value: String) {
        var nutrients = required.nutrients
        guard let original = nutrients[key], let value = Float(value) else { return }
        
        nutrients[key] = NewNutrient(id: original.id, key: key, value: value, unit: original.unit)
                
        required = NewNutritionProfile(nutrients: nutrients.map { $0.value }, id: required.id)   
    }
    
    func floatValue(key: NutrientKey) -> Float {
        return self[key].floatValue
    }
    
    func intValue(key: NutrientKey) -> Int {
        return self[key].intValue
    }
    
    static func totalProgress(nutrients: [NutrientKey: NutrientController]) -> Float {
        nutrients.map { $1.limitProgress }.reduce(0, +) / Float(nutrients.count) * 100
    }
    
    static func unit(_ key: NutrientKey) -> Unit {
        nutrientUnits[key] ?? .unknown
    }
    
    func scale(_ amount: Float) {
        let scale = amount / 100
        
        var nutrients: [Nutrient] = []
        for (key, nutrient) in _profile.nutrients {
            nutrients.append(NewNutrient(id: nutrient.id, key: key, value: nutrient.value * scale, unit: nutrient.unit))
        }
        
        objectWillChange.send()
        scalableProfile = NewNutritionProfile(nutrients: nutrients)        
    }
    
    func keys(_ category: NutrientCategory) -> [NutrientKey] {
        switch category {
        case .vitamins:
            return NutritionProfileController.vitaminKeys
        case .minerals:
            return NutritionProfileController.mineralKeys
        case .energy:
            return NutritionProfileController.energyKeys
        case .fats:
            return NutritionProfileController.fatKeys
        }
    }
    
    subscript(key: NutrientKey) -> NutrientController {
        get {
            var nutrient = profile.nutrients[key]
            if nutrient == nil { nutrient = NewNutrient(key: key, value: 0, unit: .g) }
            
            let requiredNutrient = required.nutrients[key]
            
            return NutrientController(nutrient: nutrient!, required: requiredNutrient)
        }
    }
    
    subscript(keys: [NutrientKey]) -> [NutrientController] {
        get {
            let profileAll = profile.nutrients
            let requiredAll = required.nutrients
            var nutrientControllers: [NutrientController] = []
            for key in keys {
                var nutrient = profileAll[key]
                if nutrient == nil { nutrient = NewNutrient(key: key, value: 0, unit: .g) }
                
                let required = requiredAll[key]
                
                nutrientControllers.append(NutrientController(nutrient: nutrient!, required: required))
            }
            
            return nutrientControllers
        }
    }
    
    subscript(keys: [NutrientKey]) -> [NutrientKey: NutrientController] {
        get {
            let profileAll = profile.nutrients
            let requiredAll = required.nutrients
            var nutrientControllers: [NutrientKey: NutrientController] = [:]
            for key in keys {
                var nutrient = profileAll[key]
                if nutrient == nil { nutrient = NewNutrient(key: key, value: 0, unit: .g) }
                
                let required = requiredAll[key]
                
                nutrientControllers[key] = NutrientController(nutrient: nutrient!, required: required)
            }
            
            return nutrientControllers
        }
    }
    
    subscript(category: NutrientCategory) -> [NutrientController] {
        get {
            switch category {
            case .vitamins:
                return nutrients(NutritionProfileController.vitaminKeys)
            case .minerals:
                return nutrients(NutritionProfileController.mineralKeys)
            case .energy:
                return nutrients(NutritionProfileController.energyKeys)
            case .fats:
                return nutrients(NutritionProfileController.fatKeys)
            }
        }
    }
    
    subscript(category: NutrientCategory) -> [NutrientKey: NutrientController] {
        get {
            switch category {
            case .vitamins:
                return nutrients(NutritionProfileController.vitaminKeys)
            case .minerals:
                return nutrients(NutritionProfileController.mineralKeys)
            case .energy:
                return nutrients(NutritionProfileController.energyKeys)
            case .fats:
                return nutrients(NutritionProfileController.fatKeys)
            }
        }
    }
    
    private func nutrients(_ keys: [NutrientKey]) -> [NutrientController] {
        let profileAll = profile.nutrients
        let requiredAll = required.nutrients
        var nutrients: [NutrientController] = []
        for key in keys {
            if let nutrient = profileAll[key] {
                nutrients.append(NutrientController(nutrient: nutrient, required: requiredAll[key]))
            }
        }
        
        return nutrients
    }
    
    private func nutrients(_ keys: [NutrientKey]) -> [NutrientKey: NutrientController] {
        let profileAll = profile.nutrients
        let requiredAll = required.nutrients
        var nutrients: [NutrientKey: NutrientController] = [:]
        for key in keys {
            var nutrient = profileAll[key]
            if nutrient == nil { nutrient = NewNutrient(key: key, value: 0, unit: .g) }
                        
            nutrients[key] = NutrientController(nutrient: nutrient!, required: requiredAll[key])
        }
        return nutrients
    }
}
