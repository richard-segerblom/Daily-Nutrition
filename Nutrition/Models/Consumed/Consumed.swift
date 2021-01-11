//
//  Consumed.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-02.
//

import Foundation
import CoreData

// MARK: - Consumed

protocol Consumed {
    var id: UUID { get }
    var date: Date { get }
    var eatable: Eatable? { get }
    var meal: Meal? { get }
    var nutritionProfile: NutritionProfile { get }
}

struct NewConsumed: Consumed {
    var id: UUID
    var date: Date
    var eatable: Eatable?
    var meal: Meal?
    var nutritionProfile: NutritionProfile    
}

// MARK: - Core Data

@objc(CDConsumed)
public final class CDConsumed: NSManagedObject, Consumed {
    @NSManaged public var consumedID: UUID
    @NSManaged public var date: Date
    @NSManaged public var eatableID: UUID?
    @NSManaged public var mealID: UUID?
    @NSManaged public var cdEatable: CDEatable?
    @NSManaged public var cdMeal: CDMeal?
    
    var id: UUID { consumedID }
    var eatable: Eatable? { cdEatable }
    var meal: Meal? { cdMeal }
    
    var _nutritionProfile: NutritionProfile?
    var nutritionProfile: NutritionProfile {
        if _nutritionProfile == nil {
            if let eatable = eatable {
                _nutritionProfile = eatable.nutritionProfile
            } else {
                _nutritionProfile = meal?.makeNutritionProfile()
            }
        }
        return _nutritionProfile!
    }
}

extension CDConsumed {
    @discardableResult
    convenience init(context: NSManagedObjectContext, meal: CDMeal?, eatable: CDEatable?, date: Date = Date(), consumedID: UUID = UUID()) {
        let entity = NSEntityDescription.entity(forEntityName: "CDConsumed", in: context)!

        self.init(entity: entity, insertInto: context)
        
        setValue(consumedID, forKey: "consumedID")
        setValue(meal?.mealID, forKey: "mealID")
        setValue(eatable?.eatableID, forKey: "eatableID")
        setValue(date, forKey: "date")
        
        self.cdMeal = meal
        self.cdEatable = eatable
    }
}

extension CDConsumed {
    static func latest(context: NSManagedObjectContext, limit: Int = 45) -> [CDConsumed] {
        let request = NSFetchRequest<CDConsumed>(entityName: "CDConsumed")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDConsumed.date), ascending: true)]
        request.fetchLimit = limit
        
        guard let consumed = try? context.fetch(request) else { return [] }

        for item in consumed {
            if let mealID = item.mealID {
                item.cdMeal = CDMeal.withID(mealID, context: context)
            } else if let eatableID = item.eatableID {
                item.cdEatable = CDEatable.withID(eatableID, context: context)
            }
        }
                
        return consumed
    }
    
    static func sinceDate(date: Date, context: NSManagedObjectContext) -> [CDConsumed] {
        let request = NSFetchRequest<CDConsumed>(entityName: "CDConsumed")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDConsumed.date), ascending: true)]
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(CDConsumed.date), Date() as CVarArg)
        
        guard let consumed = try? context.fetch(request) else { return [] }

        for item in consumed {
            if let mealID = item.mealID {
                item.cdMeal = CDMeal.withID(mealID, context: context)
            } else if let eatableID = item.eatableID {
                item.cdEatable = CDEatable.withID(eatableID, context: context)
            }
        }
                
        return consumed
    }
}

