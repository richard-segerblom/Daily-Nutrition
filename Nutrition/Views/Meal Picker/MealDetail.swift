//
//  MealDetail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-25.
//

import SwiftUI

struct MealDetail: View {
    let mealController: MealController
    let onEatTapped: (MealController) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HStack {
                    Text("Ingredients")
                        .padding(.vertical, titlePadding)
                        .font(.headline)
                    Spacer()
                }
                ForEach(mealController.ingredients, id:\.id) { ingredient in
                    VStack(spacing: ingredientSpacing) {
                        HStack {
                            Text(mealController.ingredientFriendlyName(ingredient))
                            Spacer()
                        }
                        .padding([.top, .leading], ingredientPadding)
                        
                        Divider()
                    }
                }                
                
                Detail(profile: mealController.nutritionProfile)
                
                DefaultButton(title: "EAT", action: { onEatTapped(mealController) })
                    .padding(.top, buttonPadding)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(mealController.name))
            .toolbar() { ToolbarItem(placement: .navigationBarTrailing) { eatButton } }
        }.padding()
    }
    
    var eatButton: some View { Button(action: { onEatTapped(mealController) }, label: { Text("Eat") }) }
    
    // MARK: - Drawing Constants
    private let titlePadding: CGFloat = 5
    private let ingredientSpacing: CGFloat = 5
    private let ingredientPadding: CGFloat = 10
    private let buttonPadding: CGFloat = 40    
}

struct MealDetail_Previews: PreviewProvider {
    static var previews: some View {
        MealDetail(mealController: PreviewData.mealController) { _ in }
    }
}
