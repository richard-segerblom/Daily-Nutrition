//
//  Energy.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-19.
//

import SwiftUI

struct Energy: View {
    @ObservedObject var profile: NutritionProfileController
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    CaloriesDetail(nutrient: profile[.sugar])
                    
                    CircularProgressBar(nutrientController: profile[.calories], text: "Calories")
                        .frame(minWidth: minCircleSize(geometry), maxWidth: maxCircleSize(geometry),
                               minHeight: minCircleSize(geometry), maxHeight: maxCircleSize(geometry))
                
                    CaloriesDetail(nutrient: profile[.fiber])
                }
                .padding(.top)
                .font(.system(size: fontSize(geometry)))
                .foregroundColor(.white)
                
                HStack(spacing: spacing) {
                    ForEach(profile[[.carbs, .protein, .fats]]) { energy in
                        EnergyDetail(nutrient: energy)
                            .font(.system(size: fontSize(geometry)))
                            .foregroundColor(.white)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        }
    }
    
    // MARK: - Drawing Constants
    private func minCircleSize(_ geometry: GeometryProxy) -> CGFloat { geometry.size.width / 4.5 }
    private func maxCircleSize(_ geometry: GeometryProxy) -> CGFloat { geometry.size.width / 2.4 }
    private func fontSize(_ geometry: GeometryProxy) -> CGFloat { 0.045 * geometry.size.width }
    private let spacing: CGFloat = 25
    private let cornerRadius: CGFloat = 25
    private let backgroundColor = Color("ProgressColor")
}

struct EnergyDetail: View {
    let nutrient: NutrientController
    
    var body: some View {
        VStack(spacing: 0){
            Text(nutrient.name)
                .padding(.bottom, padding)
            ProgressView(value: nutrient.limitProgress)
                .cornerRadius(cornerRadius)
                .accentColor(.white)
                .background(Color(#colorLiteral(red: 0.5425443053, green: 0.817581892, blue: 0.9679200053, alpha: 1)))
            Text(nutrient.percentText)
                .padding(.top, padding)
        }
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 2
    private let cornerRadius: CGFloat = 5
}

struct CaloriesDetail: View {
    let nutrient: NutrientController

    var body: some View {
        VStack {
            Text(nutrient.name)
            Text("\(nutrient.intValue) g")
        }
    }
}

struct Energy_Previews: PreviewProvider {
    static var previews: some View {
        Energy(profile: PreviewData.profileController)
            .padding()
            .previewLayout(PreviewLayout.fixed(width: 300, height: 200))
    }
}
