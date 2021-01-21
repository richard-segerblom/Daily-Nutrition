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
                    foodController.scale(newValue)
                }), in: 5...500, step: 5,  minimumValueLabel: Text("5g"), maximumValueLabel: Text("500g")) { Text("Amount") }
                    .padding(.top, padding)
                
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
            .navigationTitle(Text(foodController.name))
        }
        .padding(.horizontal)
        .foregroundColor(Color(#colorLiteral(red: 0.3985456812, green: 0.3985456812, blue: 0.3985456812, alpha: 1)))
        .onAppear { self.foodController.scale(amount) }
    }
    
    var eatButton: some View {
        DefaultButton(title: style.rawValue, action: { action(foodController, Int16(amount)) })
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 40
}

struct FoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetail(foodController: PreviewData.foodController, action: { _,_  in })
    }
}
