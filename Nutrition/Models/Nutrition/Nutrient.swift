//
//  Nutrient.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-28.
//

import Foundation
import CoreData

// MARK: - Nutrient

protocol Nutrient {
    var id: UUID { get }
    var key: NutrientKey { get }
    var name: String { get }
    var value: Float { get }
    var unit: Unit { get }
}

extension Nutrient {
    var name: String { key.rawValue }
}

struct NewNutrient: Nutrient {
    var id = UUID()
    var key: NutrientKey
    var value: Float
    var unit: Unit
}

// MARK: - Core Data

@objc(CDNutrient)
public final class CDNutrient: NSManagedObject, Nutrient  {
    @NSManaged public var nutrientID: UUID
    @NSManaged public var nutrientKey: String
    @NSManaged public var weightUnit: String
    @NSManaged public var value: Float
    @NSManaged public var nutritionProfileID: UUID
    @NSManaged public var nutritionProfile: CDNutritionProfile?

    var id: UUID { get { nutrientID } }
    var key: NutrientKey { get { NutrientKey(rawValue: nutrientKey) ?? .unknown } }
    var unit: Unit { get { Unit(rawValue: weightUnit) ?? .unknown } }
}

extension CDNutrient {
    @discardableResult
    convenience init(context: NSManagedObjectContext, key: String, unit: String, value: Float,
                     nutritionProfile: CDNutritionProfile, nutrientID: UUID = UUID()) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CDNutrient", in: context)!

        self.init(entity: entity, insertInto: context)
        
        setValue(nutrientID, forKey: "nutrientID")
        setValue(key, forKey: "nutrientKey")
        setValue(unit, forKey: "weightUnit")
        setValue(value, forKey: "value")
        setValue(nutritionProfile.nutritionProfileID, forKey: "nutritionProfileID")
        
        self.nutritionProfile = nutritionProfile
    }
}

extension CDNutrient {
    static func withProfileID(_ profileID: UUID, context: NSManagedObjectContext) -> [CDNutrient] {
        let request = NSFetchRequest<CDNutrient>(entityName: "CDNutrient")
        request.predicate = NSPredicate(format: "nutritionProfileID == %@", profileID as CVarArg)
        
        guard let result = try? context.fetch(request) else { return [] }
        
        return result
    }
    
    static func update(nutrientID: UUID, value: Float, context: NSManagedObjectContext) {
        let request = NSFetchRequest<CDNutrient>(entityName: "CDNutrient")
        request.predicate = NSPredicate(format: "nutrientID == %@", nutrientID as CVarArg)
        
        guard let result = try? context.fetch(request).first else { return }
        
        result.setValue(value, forKey: "value")
        
        try? context.save()
    }
}

// MARK: - Defines

enum NutrientKey: String, CaseIterable {
    case a = "A"
    case c = "C"
    case e = "E"
    case k = "K"
    case b1 = "B1 Thiamine"
    case b2 = "B2 Riboflavin"
    case b3 = "B3 Niacin"
    case b6 = "B6"
    case b9 = "B9 Folate"
    case b12 = "B12"
    case choline = "Choline"
    
    case calcium = "Calcium"
    case phosphorus = "Phosphorus"
    case potassium = "Potassium"
    case magnesium = "Magnesium"
    case iron = "Iron"
    case zinc = "Zinc"
    case copper = "Copper"
    case sodium = "Sodium"
    case manganese = "Manganese"
    case selenium = "Selenium"
    
    case carbs = "Carbs"
    case sugar = "Sugar"
    case fiber = "Fiber"
    case protein = "Protein"
    case fats = "Fats"
    case calories = "Calories"
    
    case saturated = "S"
    case monounsaturated = "M"
    case polyunsaturated = "P"
    case ala = "ALA"    
    case la = "LA"
    
    case unknown = "?"
}

enum Unit: String {
    case mcg = "µg"
    case mg
    case g
    case kcal
    case unknown = "?"
}
