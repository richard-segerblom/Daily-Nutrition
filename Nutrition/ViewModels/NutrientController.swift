//
//  ProfileGroupController.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-01.
//

import Foundation

class NutrientController: Identifiable {
    var nutrient: Nutrient
    var required: Nutrient?
    
    var key: NutrientKey { nutrient.key }
    
    var name: String { nutrient.name }
    
    var unit: Unit { nutrient.unit }
    
    var unitText: String { nutrient.unit.rawValue }
    
    var floatValue: Float { Float(nutrient.value) }
    
    var floatValueText: String { String(format: "%.1f", floatValue) }
    
    var floatValueDetailText: String { String(format: "%.1f", floatValue) + nutrient.unit.rawValue }
    
    var intValue: Int { Int(nutrient.value) }
    
    var intValueText: String { String("\(intValue)") }
    
    var intValueDetailText: String { String("\(intValue) " + nutrient.unit.rawValue) }
    
    var requiredIntValue: Int { Int(required?.value ?? 0) }
    
    var requiredIntValueText: String { String(Int(required?.value ?? 0)) }
    
    var requiredFloatValue: Float { Float(required?.value ?? 0.0) }
    
    var requiredfloatValueText: String { String(format: "%.1f", requiredFloatValue) }
    
    var progress: Float {
        guard let required = required else { return 0.0 }
        
        if required.value == 0 { return 0.0 }
        
        let value = Float(nutrient.value / required.value)
        if Int(value * 100) == 0 { return 0.0 }
        
        return value
    }
        
    var progressText: String {
        String(format: "%.1f", nutrient.value) + " / " + String(format: "%.1f", required?.value ?? 0)
    }
    
    var limitProgress: Float { min(1, progress) }
    
    var percent: Int { Int(progress * 100) }
    
    var percentText: String { "\(percent) %" }        
    
    init(nutrient: Nutrient, required: Nutrient?) {
        self.nutrient = nutrient
        self.required = required
    }
}
