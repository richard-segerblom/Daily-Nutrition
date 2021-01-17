//
//  ConsumedRow.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import SwiftUI

struct ConsumedRow: View {
    let consumedController: ConsumedController
    
    var body: some View {
        Row(name: consumedController.name,
            calories: consumedController.caloriesText,
            icon: icon)
    }
    
    var icon: Image {
        if let category = consumedController.foodCategory {
            return Image.icon(category)
        }
        if let category = consumedController.mealCategory {
            return Image.icon(category)
        }
        
        return Image(systemName: "questionmark")
    }
}

struct ConsumedRow_Previews: PreviewProvider {
    static var previews: some View {        
        ConsumedRow(consumedController: PreviewData.consumedController)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
