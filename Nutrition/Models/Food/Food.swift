//
//  Food.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-29.
//

import Foundation
import CoreData

// MARK: - Food

protocol Food {
    var id: UUID { get }
    var name: String { get }
    var category: FoodCategory { get }
    var profile: NutritionProfile { get }
}

struct NewFood: Food {
    var id: UUID    
    var name: String
    var category: FoodCategory
    var profile: NutritionProfile
}

// MARK: - Core Data

@objc(CDFood)
public final class CDFood: NSManagedObject, Food {
    @NSManaged public var foodID: UUID
    @NSManaged public var name: String
    @NSManaged public var foodCategory: Int16
    @NSManaged public var nutritionProfileID: UUID
    @NSManaged public var nutritionProfile: CDNutritionProfile!
    
    @NSManaged public var existsInEatables: NSSet?
    @NSManaged public var existsInIngredients: CDIngredient?
    
    var id: UUID { foodID }
    var category: FoodCategory { FoodCategory(rawValue: foodCategory) ?? .pantry }
    var profile: NutritionProfile { nutritionProfile }
}
    
extension CDFood {
    @discardableResult
    convenience init(context: NSManagedObjectContext, name: String, category: Int16,
                      nutritionProfile: CDNutritionProfile, foodID: UUID = UUID()) {
                  
        let entity = NSEntityDescription.entity(forEntityName: "CDFood", in: context)!

        self.init(entity: entity, insertInto: context)
        
        setValue(foodID, forKey: "foodID")
        setValue(name, forKey: "name")
        setValue(category, forKey: "foodCategory")
        setValue(nutritionProfile.nutritionProfileID, forKey: "nutritionProfileID")
        
        self.nutritionProfile = nutritionProfile
    }
}

extension CDFood {
    static func all(context: NSManagedObjectContext) -> [CDFood] {
        let request = NSFetchRequest<CDFood>(entityName: "CDFood")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDFood.name), ascending: true)]
        
        guard let foods = try? context.fetch(request) else { return [] }

        for food in foods {
            food.nutritionProfile = CDNutritionProfile.withID(food.nutritionProfileID, context: context)
        }
                
        return foods
    }
    
    static func withID(_ id: UUID, context: NSManagedObjectContext) -> CDFood? {
        let request = NSFetchRequest<CDFood>(entityName: "CDFood")
        request.predicate = NSPredicate(format: "foodID == %@", id as CVarArg)
        
        guard let food = try? context.fetch(request).first else { return nil }
        
        food.nutritionProfile = CDNutritionProfile.withID(food.nutritionProfileID, context: context)
                
        return food
    }
}

extension CDFood {
    @objc(addExistsInEatablesObject:)
    @NSManaged public func addToExistsInEatables(_ value: CDEatable)

    @objc(removeExistsInEatablesObject:)
    @NSManaged public func removeFromExistsInEatables(_ value: CDEatable)

    @objc(addExistsInEatables:)
    @NSManaged public func addToExistsInEatables(_ values: NSSet)

    @objc(removeExistsInEatables:)
    @NSManaged public func removeFromExistsInEatables(_ values: NSSet)
}

extension CDFood {
    @objc(addExistsInIngredientsObject:)
    @NSManaged public func addToExistsInIngredients(_ value: CDIngredient)

    @objc(removeExistsInIngredientsObject:)
    @NSManaged public func removeFromExistsInIngredients(_ value: CDIngredient)

    @objc(addExistsInIngredients:)
    @NSManaged public func addToExistsInIngredients(_ values: NSSet)

    @objc(removeExistsInIngredients:)
    @NSManaged public func removeFromExistsInIngredients(_ values: NSSet)
}

// MARK: - Defines

enum FoodCategory: Int16, CaseIterable {
    case fruit
    case vegetables
    case meat
    case seafood
    case dairy
    case pantry
}
