//
//  ProfileGroupController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-01.
//

import Foundation

class NutrientValue: Identifiable {
    let nutrient: Nutrient
    let required: Nutrient?
    
    var name: String { nutrient.name }
    
    var floatValue: Float { Float(nutrient.value) }
    
    var floatValueText: String { String(format: "%.1f", floatValue) + nutrient.unit.rawValue }
    
    var intValue: Int { Int(nutrient.value) }
    
    var intValueText: String { String("\(intValue) " + nutrient.unit.rawValue) }
    
    var requiredIntValue: Int { Int(required?.value ?? 0) }
    
    var progress: Float {
        guard let required = required else { return 0.0 }
        
        if required.value == 0 { return 1.0 }
        
        let value = Float(nutrient.value / required.value)
        if Int(value * 100) == 0 { return 0.0 }
        
        return value
    }
        
    var progressText: String { "\(nutrient.value) / \(required?.value ?? 0) " + nutrient.unit.rawValue }
    
    var limitProgress: Float { min(1, progress) }
    
    var percent: Int { Int(progress * 100) }
    
    var percentText: String { "\(percent) %" }
    
    
    init(nutrient: Nutrient, required: Nutrient?) {
        self.nutrient = nutrient
        self.required = required
    }
}
