//
//  MealRow.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-04.
//

import SwiftUI

struct MealRow: View {
    let mealController: MealController
    
    var body: some View {
        Row(name: mealController.name,
            calories: mealController.caloriesText,
            icon: Image.icon(mealController.category))
    }       
}

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        MealRow(mealController: PreviewData.mealController)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
