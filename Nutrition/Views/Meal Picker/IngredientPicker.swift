//
//  IngredientPicker.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-13.
//

import SwiftUI

struct IngredientPicker: View {
    @ObservedObject var foodStorage: FoodStorageController
    let action: (FoodController, Int16) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            FoodList(foodStorage: foodStorage, title: "Pick Ingredient", style: .ingredient) { (food, amount) in
                action(food, amount)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct IngredientPicker_Previews: PreviewProvider {
    static var previews: some View {
        IngredientPicker(foodStorage: PreviewData.foodStorage) { _,_ in }
    }
}
