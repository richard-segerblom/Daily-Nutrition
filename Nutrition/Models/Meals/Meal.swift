//
//  CDMeal.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//
//

import Foundation
import CoreData

// MARK: - Meal

protocol Meal {
    var id: UUID { get }
    var name: String { get }
    var date: Date { get }
    var ingredients: [Ingredient] { get }
    var nutritionProfile: NutritionProfile { mutating get }
    
    func makeNutritionProfile() -> NutritionProfile
}

extension Meal {
    func makeNutritionProfile() -> NutritionProfile {
        var profile: NutritionProfile = NewNutritionProfile(nutrients: [])
        for ingredient in ingredients {
            profile = ingredient.nutritionProfile.merged(other: profile)
        }
        return profile
    }
}

struct NewMeal: Meal {
    var id: UUID
    var name: String
    var date: Date
    var ingredients: [Ingredient]
    
    private var _nutritionProfile: NutritionProfile?
    var nutritionProfile: NutritionProfile {
        mutating get {
            if _nutritionProfile == nil {
                _nutritionProfile = makeNutritionProfile()
            }
            return _nutritionProfile!
        }
    }
    
    init(id: UUID, name: String, date: Date, ingredients: [Ingredient]) {
        self.id = id
        self.name = name
        self.date = date
        self.ingredients = ingredients
    }
}


// MARK: - Core Data

@objc(CDMeal)
public final class CDMeal: NSManagedObject, Meal {
    @NSManaged public var creationDate: Date
    @NSManaged public var mealCategory: Int16
    @NSManaged public var mealID: UUID
    @NSManaged public var name: String
    @NSManaged public var cdIngredients: NSSet!
    @NSManaged public var existsInConsumed: NSSet?
    
    var id: UUID { mealID }
    var date: Date { creationDate }
    var ingredients: [Ingredient] { (cdIngredients.allObjects as! [Ingredient]).sorted { $0.sortOrder < $1.sortOrder } }
    
    private var _nutritionProfile: NutritionProfile?
    var nutritionProfile: NutritionProfile {
        if _nutritionProfile == nil {
            _nutritionProfile = makeNutritionProfile()
        }
        return _nutritionProfile!
    }
}
    
extension CDMeal {
    var category: FoodCategory {
        return FoodCategory(rawValue: mealCategory)!
    }
}
 
extension CDMeal {
    @discardableResult
    convenience init(context: NSManagedObjectContext, name: String, foodCategory: FoodCategory, creationDate: Date = Date(), mealID: UUID = UUID()) {
        let entity = NSEntityDescription.entity(forEntityName: "CDMeal", in: context)!
                        
        self.init(entity: entity, insertInto: context)
            
        setValue(mealID, forKey: "mealID")
        setValue(name, forKey: "name")
        setValue(creationDate, forKey: "creationDate")
        setValue(foodCategory.rawValue, forKey: "foodCategory")
    }
}

extension CDMeal {
    static func withID(_ id: UUID, context: NSManagedObjectContext) -> CDMeal? {
        let request = NSFetchRequest<CDMeal>(entityName: "CDMeal")
        request.predicate = NSPredicate(format: "mealID == %@", id as CVarArg)
        
        guard let meal = try? context.fetch(request).first else { return nil }
                        
        meal.cdIngredients = NSSet(array: CDIngredient.inMeal(mealID: meal.mealID, context: context))
                        
        return meal
    }
}
 
extension CDMeal {
    @objc(addExistsInConsumedObject:)
    @NSManaged public func addToExistsInConsumed(_ value: CDConsumed)

    @objc(removeExistsInConsumedObject:)
    @NSManaged public func removeFromExistsInConsumed(_ value: CDConsumed)

    @objc(addExistsInConsumed:)
    @NSManaged public func addToExistsInConsumed(_ values: NSSet)

    @objc(removeExistsInConsumed:)
    @NSManaged public func removeFromExistsInConsumed(_ values: NSSet)
}

extension CDMeal {
    @objc(addCdIngredientsObject:)
    @NSManaged public func addToCdIngredients(_ value: CDIngredient)

    @objc(removeCdIngredientsObject:)
    @NSManaged public func removeFromCdIngredients(_ value: CDIngredient)

    @objc(addCdIngredients:)
    @NSManaged public func addToCdIngredients(_ values: NSSet)

    @objc(removeCdIngredients:)
    @NSManaged public func removeFromCdIngredients(_ values: NSSet)
}

// MARK: - Defines

enum MealCategory: Int16, CaseIterable {
    case all
    case breakfast
    case lunch
    case dinner
    case snack
}
