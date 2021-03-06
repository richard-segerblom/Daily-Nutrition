//
//  FoodDetail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-22.
//

import SwiftUI
import Combine

struct FoodDetail: View {
    let foodController: FoodController
    let style: PickerStyle
    let action: (FoodController, Int16) -> Void
        
    @State private var amount: Float = 100.0
    
    init(foodController: FoodController, style: PickerStyle = .food, action: @escaping (FoodController, Int16) -> Void) {
        self.foodController = foodController
        self.style = style
        self.action = action        
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Slider(value: Binding(get: { amount }, set: { (newValue) in
                    amount = newValue
                    foodController.scale(newValue / 100)
                }), in: 5...500, step: 5,  minimumValueLabel: Text("5g"), maximumValueLabel: Text("500g")) { Text("Amount") }
                .padding(.top, padding)
                .accessibility(identifier: "amountPicker")
                
                Text("\(amount, specifier: "%.0f")g")
                    .padding(.bottom)
                    .font(.title2)
                                
                eatButton                    
                
                Detail(profile: foodController)
                    .padding(.bottom, padding)
                
                eatButton
                    .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(foodController.detailName))
        }
        .padding(.horizontal)
        .foregroundColor(textColor)
        .onAppear { self.foodController.scale(amount / 100) }
    }
    
    var eatButton: some View {
        DefaultButton(title: style.rawValue, action: { action(foodController, Int16(amount)) })
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 40
    private let textColor = Color("PrimaryTextColor")
}

struct FoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetail(foodController: PreviewData.foodController, action: { _,_  in })
    }
}
