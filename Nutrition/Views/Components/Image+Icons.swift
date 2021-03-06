//
//  Image+Icons.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-16.
//

import SwiftUI

extension Image {
    static func icon(_ category: FoodCategory) -> Image {
        switch category {
        case .fruit:
            return Image(systemName: "f.circle.fill")
        case .vegetables:
            return Image(systemName: "v.circle.fill")
        case .nuts:
            return Image(systemName: "n.circle.fill")
        case .legumes:
            return Image(systemName: "l.circle.fill")
        case .grains:
            return Image(systemName: "g.circle.fill")
        default:
            return Image(systemName: "a.circle.fill")        
        }
    }
    
    static func icon(_ category: MealCategory) -> Image {
        switch category {
        case .breakfast:
            return Image(systemName: "b.circle.fill")
        case .lunch:
            return Image(systemName: "l.circle.fill")
        case .dinner:
            return Image(systemName: "d.circle.fill")
        default:
            return Image(systemName: "s.circle.fill")
        }
    }
    
    static func icon(_ consumedController: ConsumedController) -> Image {
        if let category = consumedController.foodCategory {
            return self.icon(category)
        }
        if let category = consumedController.mealCategory {
            return self.icon(category)
        }
        
        return Image(systemName: "questionmark")
    }
}
