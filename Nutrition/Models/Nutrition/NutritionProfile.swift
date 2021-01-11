//
//  NutritionProfile.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-28.
//

import Foundation
import CoreData

// MARK: - Nutrition Profile

protocol NutritionProfile {
    var id: UUID { get }
    var nutrients: [NutrientKey: Nutrient] { get }
    
    func scale(_ factor: Float) -> NutritionProfile
    func merged(other: NutritionProfile) -> NutritionProfile
}

extension NutritionProfile {
    func scale(_ factor: Float) -> NutritionProfile {
        var all: [Nutrient] = []
        
        for (key, nutrient) in nutrients {            
            all.append(NewNutrient(id: nutrient.id, key: key, value: nutrient.value * factor, unit: nutrient.unit))
        }
        
        return NewNutritionProfile(nutrients: all)
    }
    
    func merged(other: NutritionProfile) -> NutritionProfile {
        var all: [Nutrient] = []
        for (key, nutrient) in nutrients {            
            let value = nutrient.value + (other.nutrients[key]?.value ?? 0)
            all.append(NewNutrient(id: nutrient.id, key: nutrient.key, value: value, unit: nutrient.unit))
        }
        return NewNutritionProfile(nutrients: all)
    }
}

struct NewNutritionProfile: NutritionProfile {
    var id: UUID
    var nutrients: [NutrientKey : Nutrient] = [:]
    
    init(nutrients: [Nutrient], id: UUID = UUID()) {
        self.id = id
        
        var all: [NutrientKey : Nutrient] = [:]
        for nutrient in nutrients { all[nutrient.key] = nutrient }
        self.nutrients = all
    }
}


// MARK: - Core Data

@objc(CDNutritionProfile)
public final class CDNutritionProfile: NSManagedObject {
    @NSManaged public var nutritionProfileID: UUID
    @NSManaged public var food: CDFood?
    @NSManaged public var allNutrients: NSSet?
}

extension CDNutritionProfile: NutritionProfile {
    var id: UUID { nutritionProfileID }
    
    var nutrients: [NutrientKey : Nutrient] {
        var all: [NutrientKey : Nutrient] = [:]
        guard let nutrients = allNutrients?.allObjects as? [Nutrient] else { return all }
        
        for nutrient in nutrients {
            all[nutrient.key] = nutrient
        }
        
        return all
    }
}

extension CDNutritionProfile {
    @objc(addAllNutrientsObject:)
    @NSManaged public func addToAllNutrients(_ value: CDNutrient)

    @objc(removeAllNutrientsObject:)
    @NSManaged public func removeFromAllNutrients(_ value: CDNutrient)

    @objc(addAllNutrients:)
    @NSManaged public func addToAllNutrients(_ values: NSSet)

    @objc(removeAllNutrients:)
    @NSManaged public func removeFromAllNutrients(_ values: NSSet)
}

extension CDNutritionProfile {
    @discardableResult
    convenience init(context: NSManagedObjectContext, food: CDFood?, id: UUID = UUID()) {
        let entity = NSEntityDescription.entity(forEntityName: "CDNutritionProfile", in: context)!

        self.init(entity: entity, insertInto: context)
        
        setValue(id, forKey: "nutritionProfileID")
        
        self.food = food
    }
}

extension CDNutritionProfile {
    static func withID(_ id: UUID, context: NSManagedObjectContext) -> CDNutritionProfile? {
        let request = NSFetchRequest<CDNutritionProfile>(entityName: "CDNutritionProfile")
        request.predicate = NSPredicate(format: "nutritionProfileID == %@", id as CVarArg)        
        
        guard let profile = try? context.fetch(request).first else { return nil }
                        
        let nutrients = CDNutrient.withProfileID(profile.nutritionProfileID, context: context)
        profile.addToAllNutrients(NSSet(array: nutrients))
        
        return profile
    }
    
    static func add(profile: NutritionProfile, context: NSManagedObjectContext) -> NutritionProfile {
        let nutritionProfile = CDNutritionProfile(context: context, food: nil)
        for (key, nutrient) in profile.nutrients {
            CDNutrient(context: context, key: key.rawValue, unit: nutrient.unit.rawValue, value: nutrient.value, nutritionProfile: nutritionProfile)
        }

        try? context.save()
                        
        return nutritionProfile
    }
}

