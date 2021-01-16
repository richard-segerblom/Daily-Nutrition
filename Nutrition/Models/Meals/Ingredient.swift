//
//  CDIngredient.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//
//

import Foundation
import CoreData

// MARK: - Ingredient

protocol Ingredient {
    var id: UUID { get }
    var amount: Int16 { get }
    var sortOrder: Int16 { get }
    var food: Food { get }
    var nutritionProfile: NutritionProfile { get }
}

struct NewIngredient: Ingredient {
    var id: UUID
    var amount: Int16
    var sortOrder: Int16
    var food: Food
    var nutritionProfile: NutritionProfile {
        get { food.profile.scale(Float(amount) / 100) }
    }
}

// MARK: - Core Data

@objc(CDIngredient)
public final class CDIngredient: NSManagedObject, Ingredient {
    @NSManaged public var ingredientID: UUID
    @NSManaged public var foodID: UUID
    @NSManaged public var mealID: UUID
    @NSManaged public var amount: Int16
    @NSManaged public var sortOrder: Int16
    @NSManaged public var cdFood: CDFood!
    @NSManaged public var meal: CDMeal!
    
    var id: UUID { ingredientID }
    var food: Food  { cdFood }
    
    private var _nutritionProfile: NutritionProfile? = nil
    var nutritionProfile: NutritionProfile {
        if _nutritionProfile == nil {
            _nutritionProfile = cdFood.nutritionProfile.scale(Float(amount) / 100)
        }
        return _nutritionProfile!
    }
}
    
extension CDIngredient {
    @discardableResult
    convenience init(context: NSManagedObjectContext, amount: Int16, sortOrder: Int16, food: CDFood, meal: CDMeal?, ingredientID: UUID = UUID()) {
                  
        let entity = NSEntityDescription.entity(forEntityName: "CDIngredient", in: context)!

        self.init(entity: entity, insertInto: context)
        
        setValue(ingredientID, forKey: "ingredientID")
        setValue(amount, forKey: "amount")
        setValue(sortOrder, forKey: "sortOrder")
        setValue(food.foodID, forKey: "foodID")
        setValue(meal?.mealID, forKey: "mealID")
        
        self.cdFood = food
        self.meal = meal
    }
}

extension CDIngredient {
    static func inMeal(mealID: UUID, context: NSManagedObjectContext) -> [CDIngredient] {
        let request = NSFetchRequest<CDIngredient>(entityName: "CDIngredient")
        request.predicate = NSPredicate(format: "mealID == %@", mealID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDIngredient.sortOrder), ascending: true)]
        
        guard let ingredients = try? context.fetch(request) else { return [] }
        
        for ingredient in ingredients {
            ingredient.cdFood = CDFood.withID(ingredient.foodID, context: context)
        }
                
        return ingredients
    }
}
