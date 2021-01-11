//
//  Fats.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-22.
//

import SwiftUI

struct Fats: View {
    @ObservedObject var profile: NutritionProfileController
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: spacingTop) {
                    Group {
                        CircularProgressBar(nutrientController: profile[.ala], text: "ALA", decimalNumber: true)
                        CircularProgressBar(nutrientController: profile[.la], text: "LA", decimalNumber: true)
                    }
                    .frame(minWidth: minCircleSize(geometry), maxWidth: maxCircleSize(geometry),
                           minHeight: minCircleSize(geometry), maxHeight: maxCircleSize(geometry))
                }
                .padding(.top)
                .font(.system(size: fontSize(geometry)))
                .foregroundColor(.white)
                
                HStack(spacing: spacingBottom(geometry)) {
                    ForEach(profile[[.saturated, .monounsaturated, .polyunsaturated]]) { fat in
                        VStack(spacing: 0){
                            Text(fat.name)
                            Text(fat.floatValueText)
                        }
                        .font(.system(size: fontSize(geometry)))
                        .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.horizontal, .bottom])
            }
            .background(Color("ProgressColor"))
            .cornerRadius(cornerRadius)
        }
    }
    
    // MARK: - Drawing Constants
    private func minCircleSize(_ geometry: GeometryProxy) -> CGFloat { geometry.size.width / 4.1 }
    private func maxCircleSize(_ geometry: GeometryProxy) -> CGFloat { geometry.size.width / 3 }
    private func fontSize(_ geometry: GeometryProxy) -> CGFloat { 0.045 * geometry.size.width }
    private func spacingBottom(_ geometry: GeometryProxy) -> CGFloat { 0.12 * geometry.size.width }
    private let spacingTop: CGFloat = 40
    private let cornerRadius: CGFloat = 25
}

struct Fats_Previews: PreviewProvider {
    static var previews: some View {
        Fats(profile: PreviewData.profileController)
            .padding()
            .previewLayout(PreviewLayout.fixed(width: 300, height: 200))
    }
}
