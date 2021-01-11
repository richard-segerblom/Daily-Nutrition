//
//  Detail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-11.
//

import SwiftUI

struct Detail: View {
    @ObservedObject var profile: NutritionProfileController
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        VStack {
            VStack {
                NutrientSection(title: "VITAMINS", nutrientControllers: profile[.vitamins], keys: NutritionProfileController.vitaminKeys)
                    .padding(.bottom)
                                                
                if sizeClass == .regular {
                    NutrientSection(title: "MINERALS", nutrientControllers: profile[.minerals], keys: NutritionProfileController.mineralKeys)
                        .padding(.bottom, paddingBottom)
                } else {
                    NutrientSection(title: "MINERALS", nutrientControllers: profile[.minerals], keys: NutritionProfileController.mineralKeys)
                        .padding(.bottom)
                    NutrientSection(title: "FATS", nutrientControllers: profile[[.ala, .la]], keys: [.ala, .la])
                                        
                    HStack(spacing: horizontalSpacingFats) {
                        ForEach(profile[[.saturated, .monounsaturated, .polyunsaturated]]) { nutrientController in
                            VStack(spacing: 0){
                                Text(nutrientController.nutrient.name)
                                Text(nutrientController.floatValueText)
                            }
                        }
                    }
                }
            }
            .foregroundColor(Color(#colorLiteral(red: 0.3985456812, green: 0.3985456812, blue: 0.3985456812, alpha: 1)))
            .padding(.top)
            
            if sizeClass == .regular {
                HStack(spacing: horizontalSpacingComponents) {
                    Energy(profile: profile).frame(height: componentHeight)
                    Fats(profile: profile).frame(height: componentHeight)
                }
            } else {
                Energy(profile: profile).frame(height: componentHeight)
            }
        }
    }
    
    // Drawing Constants
    private let componentHeight: CGFloat = 180
    private let horizontalSpacingFats: CGFloat = 40
    private let horizontalSpacingComponents: CGFloat = 20
    private let paddingBottom: CGFloat = 30
}

struct NutrientSection: View {
    let title: String
    let nutrientControllers: [NutrientKey: NutrientController]
    let keys: [NutrientKey]
    
    var body: some View {
        VStack(spacing: spacing) {
            Text(title)
                .font(.headline)
            
            ForEach(keys, id:\.self) { key in
                let nutrientController = nutrientControllers[key]
                HStack {
                    Text(key.rawValue)
                    Spacer()
                    Text(nutrientController?.percentText ?? "0 %")
                }
                .font(.subheadline)
                
                ProgressView(value: nutrientController?.limitProgress ?? 0)
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let spacing: CGFloat = 2
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(profile: PreviewData.profileController)
            .previewLayout(PreviewLayout.fixed(width: 350, height: 1000))
            .padding()
    }
}

