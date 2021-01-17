//
//  FoodRow.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-18.
//

import SwiftUI

struct FoodRow: View {
    let foodController: FoodController
    
    var body: some View {
        Row(name: foodController.name,
            calories: foodController.caloriesText,
            icon: Image.icon(foodController.category))
    }       
}

struct FoodRow_Previews: PreviewProvider {
    static var previews: some View {
        FoodRow(foodController: PreviewData.foodController)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
