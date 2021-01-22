//
//  CircularProgressView.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-11-24.
//

import SwiftUI

struct CircularProgressBar: View {
    let nutrientController: NutrientController
    let text: String
    let decimalNumber: Bool
    
    init(nutrientController: NutrientController, text: String = "", decimalNumber: Bool = false) {
        self.nutrientController = nutrientController
        self.text = text
        self.decimalNumber = decimalNumber
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                ZStack {
                    Group {
                        Circle()
                            .trim(from: 0, to: 1 - CGFloat(self.sliceSize))
                            .stroke(trackColor, style: self.strokeStyle(with: geometry))
                            .opacity(0.5)
                            .scaleEffect(0.9)
                        Circle()
                            .trim(from: 0, to: (1 - CGFloat(self.sliceSize)) * CGFloat(nutrientController.limitProgress))
                            .stroke(progressColor, style: self.strokeStyle(with: geometry))
                            .scaleEffect(0.9)
                    }
                    .rotationEffect(.degrees(90) + .degrees(360 * self.sliceSize / 2))
                    
                    VStack {
                        Group {
                            if decimalNumber { Text(nutrientController.floatValueText) }
                            else { Text(nutrientController.intValueText) }
                        }
                        .font(.system(size: fontSize(geometry), weight: .regular, design: .rounded))
                        .padding(.bottom, padding)
                        
                        RoundedRectangle(cornerRadius: seperatorCornerRadius)
                            .frame(width: seperatorWidth(geometry), height: seperatorHeight(geometry))
                        
                        Group {
                            if decimalNumber { Text(nutrientController.requiredfloatValueText) }
                            else { Text(nutrientController.requiredIntValueText) }
                        }
                        .font(.system(size: fontSize(geometry), weight: .regular, design: .rounded))
                        .padding(.top, padding)                        
                        
                        Text(text)
                            .font(.system(size: titleSize(geometry), weight: .regular, design: .rounded))
                            .offset(x: 0, y: titleOffsetY)
                    }
                    .offset(y: textOffset(geometry))
                }
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let sliceSize = 0.35
    private let trackColor = Color("TrackColor")
    private let progressColor = Color("SecondaryProgressColor")
    private let padding: CGFloat = -8
    private let titleOffsetY: CGFloat = 5
    private let seperatorCornerRadius: CGFloat = 2
    private func textOffset(_ geometry: GeometryProxy) -> CGFloat { 0.05 * geometry.size.width }
    private func seperatorWidth(_ geometry: GeometryProxy) -> CGFloat { abs(min(geometry.size.width, geometry.size.height) / 2.5) }
    private func seperatorHeight(_ geometry: GeometryProxy) -> CGFloat { abs(0.01 * geometry.size.height) }
    private func fontSize(_ geometry: GeometryProxy) -> CGFloat { 0.18 * min(geometry.size.width, geometry.size.height) }
    private func titleSize(_ geometry: GeometryProxy) -> CGFloat { 0.2 * min(geometry.size.width, geometry.size.height) }
    private func strokeStyle(with geometry: GeometryProxy) -> StrokeStyle {
        StrokeStyle(lineWidth: 0.12 * min(geometry.size.width, geometry.size.height), lineCap: .round)
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(nutrientController: PreviewData.nutrientController, text: "Calories",
                            decimalNumber: false)
            .previewLayout(PreviewLayout.fixed(width: 250, height: 250))
            .padding()
            .background(Color.gray)
    }
}
