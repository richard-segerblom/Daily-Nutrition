//
//  Eatable.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-02.
//

import Foundation
import CoreData

// MARK: - Eatable

protocol Eatable {
    var id: UUID { get }
    var food: Food { get }
    var amount: Int16 { get }
    var nutritionProfile: NutritionProfile { get }
}

struct NewEatable: Eatable {
    var id: UUID
    var food: Food
    var amount: Int16
    var nutritionProfile: NutritionProfile
}

// MARK: - Core Data

@objc(CDEatable)
public final class CDEatable: NSManagedObject, Eatable {
    @NSManaged public var eatableID: UUID
    @NSManaged public var amount: Int16
    @NSManaged public var foodID: UUID
    @NSManaged public var cdFood: CDFood!
    @NSManaged public var existsInConsumed: NSSet?
    
    var id: UUID { eatableID }
    var food: Food { cdFood }
    
    private var _nutritionProfile: NutritionProfile? = nil
    var nutritionProfile: NutritionProfile {
        if _nutritionProfile == nil {            
            let scale = Float(amount) / 100
            _nutritionProfile = cdFood.nutritionProfile.scale(scale)
        }
        return _nutritionProfile!
    }
}

extension CDEatable {
    @discardableResult
    convenience init(context: NSManagedObjectContext, amount: Int16, food: CDFood, eatableID: UUID = UUID()) {
        let entity = NSEntityDescription.entity(forEntityName: "CDEatable", in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        setValue(eatableID, forKey: "eatableID")
        setValue(amount, forKey: "amount")
        setValue(food.foodID, forKey: "foodID")
        
        self.cdFood = food
    }
}

extension CDEatable {
    static func withID(_ id: UUID, context: NSManagedObjectContext) -> CDEatable? {
        let request = NSFetchRequest<CDEatable>(entityName: "CDEatable")
        request.predicate = NSPredicate(format: "eatableID == %@", id as CVarArg)
        
        guard let eatable = try? context.fetch(request).first else { return nil }
                        
        eatable.cdFood = CDFood.withID(eatable.foodID, context: context)
                        
        return eatable
    }
}

extension CDEatable {
    @objc(addExistsInConsumedObject:)
    @NSManaged public func addToExistsInConsumed(_ value: CDConsumed)

    @objc(removeExistsInConsumedObject:)
    @NSManaged public func removeFromExistsInConsumed(_ value: CDConsumed)

    @objc(addExistsInConsumed:)
    @NSManaged public func addToExistsInConsumed(_ values: NSSet)

    @objc(removeExistsInConsumed:)
    @NSManaged public func removeFromExistsInConsumed(_ values: NSSet)
}
