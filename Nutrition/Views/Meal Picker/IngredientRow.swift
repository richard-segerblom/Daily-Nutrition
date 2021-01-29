//
//  IngredientRow.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-29.
//

import SwiftUI

struct IngredientRow: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text("\(ingredient.amount)g")
                .frame(width: amountWidth, alignment: .leading)
            Text("\(ingredient.food.name)")
            Spacer()
        }
    }
    
    // MARK: - Drawing Constants
    let amountWidth: CGFloat = 60
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        IngredientRow(ingredient: PreviewData.mealController.ingredients.first!)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 50))
    }
}
