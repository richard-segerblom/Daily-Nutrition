//
//  Persistence.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import CoreData

final class Loader {
    class func populate(_ context: NSManagedObjectContext, file: String, bundle: Bundle = Bundle.main) {
        let path = bundle.path(forResource: file, ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]

            for object in result {
                if let jsonObject = object as? [String : Any] {                    
                    parse(jsonObject: jsonObject, context: context)
                }
                                
                try context.save()
            }
        } catch {  fatalError("Unable to pre populate food storage: \(error.localizedDescription)") }
    }

    @discardableResult
    private class func parse(jsonObject: [String: Any], context: NSManagedObjectContext) -> Food? {
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
}
