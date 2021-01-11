//
//  MealDetail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-25.
//

import SwiftUI

struct MealDetail: View {
    let mealController: MealController        
    
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
                
                DefaultButton(title: "EAT", action: { /* TODO Implement eat meal */ })
                    .padding(.top, buttonPadding)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(mealController.name))
        }.padding()
    }
    
    // MARK: - Drawing Constants
    private let titlePadding: CGFloat = 5
    private let ingredientSpacing: CGFloat = 5
    private let ingredientPadding: CGFloat = 10
    private let buttonPadding: CGFloat = 40    
}

struct MealDetail_Previews: PreviewProvider {
    static var previews: some View {
        MealDetail(mealController: PreviewData.mealController)
    }
}
