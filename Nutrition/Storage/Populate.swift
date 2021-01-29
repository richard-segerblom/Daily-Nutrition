//
//  Populate.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import CoreData

final class Populate {
    class func storageWithFood(_ context: NSManagedObjectContext, file: String, bundle: Bundle = Bundle.main) throws {
        guard let path = bundle.path(forResource: file, ofType: "json") else { throw PrepopulateError.invalidFile }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        
        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject]
        guard let objects = result else { throw PrepopulateError.convertJSONFailed }

        for object in objects {
            if let jsonObject = object as? [String : Any] {
                parseFood(jsonObject: jsonObject, context: context)
            }
        }
        try context.save()
    }
    
    class func storageWithMeals(_ context: NSManagedObjectContext, file: String = "Meals", bundle: Bundle = Bundle.main) throws {
        guard let path = bundle.path(forResource: file, ofType: "json") else { throw PrepopulateError.invalidFile }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject]
        guard let objects = result else { throw PrepopulateError.convertJSONFailed }
        
        for object in objects {
            if let jsonObject = object as? [String : Any] {
                parseMeal(jsonObject: jsonObject, context: context)
            }
        }
        try context.save()
    }

    @discardableResult
    private class func parseFood(jsonObject: [String: Any], context: NSManagedObjectContext) -> Food? {
        guard let name = jsonObject["Food Name"] as? String else { return nil }
        guard let category = (jsonObject["Category"] as? NSNumber)?.int16Value else { return nil }
        guard let nutrientRows = jsonObject["Nutrients"] as? [[String : AnyObject]] else { return nil }
        
        let nutritionProfile = CDNutritionProfile(context: context, food: nil)
        let food = CDFood(context: context, name: name, category: category, nutritionProfile: nutritionProfile)
        
        var nutrients: [CDNutrient] = []
        for row in nutrientRows {
            guard let key = row["Key"] as? String else { continue }
            guard let unit = row["Unit"] as? String else { continue }
            guard let value = row["Value"] as? NSNumber else { continue }
            
            let nutrient = CDNutrient(context: context, key: key, unit: unit, value: value.floatValue, nutritionProfile: nutritionProfile)
            nutrients.append(nutrient)
        }
        
        return food
    }
    
    @discardableResult
    private class func parseMeal(jsonObject: [String: Any], context: NSManagedObjectContext) -> Meal? {
        guard let name = jsonObject["Name"] as? String else { return nil }
        guard let rawCategory = (jsonObject["Category"] as? NSNumber)?.int16Value else { return nil }
        guard let category = MealCategory(rawValue: rawCategory) else { return nil }
        guard let ingredientRows = jsonObject["Ingredients"] as? [[String : AnyObject]] else { return nil }
        
        let food = CDFood.all(context: context)
        
        let meal = CDMeal(context: context, name: name, mealCategory: category)
        var ingredients: [CDIngredient] = []
        for row in ingredientRows {
            guard let amount = row["Amount"] as? Int16 else { continue }
            guard let sortOrder = row["SortOrder"] as? Int16 else { continue }
            guard let foodName = row["Food Name"] as? String else { continue }
            
            guard let food = food.first(where: { $0.name == foodName }) else { continue }
            
            let ingredient = CDIngredient(context: context, amount: amount, sortOrder: sortOrder, food: food, meal: meal)
            ingredients.append(ingredient)
        }
        
        meal.addToCdIngredients(NSSet(array: ingredients))
        
        return meal
    }
}

enum PrepopulateError: Error {
    case invalidFile
    case convertJSONFailed
}

enum FoodFileNames: String {
    case fruits     = "Fruits"
    case vegetables = "Vegetables"
    case nuts       = "Nuts"
    case legumes    = "Legumes"
    case grains     = "Grains"
    case animal     = "Animal"
}
