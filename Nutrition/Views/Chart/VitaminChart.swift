//
//  VitaminChart.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-15.
//

import SwiftUI

struct VitaminChart: View {
    let nutrients: [NutrientKey: NutrientController]
    let title: String
    let spacing: CGFloat
    let barWidth: CGFloat
    let height: CGFloat
    let labelLength: Int
    
    init(nutrients: [NutrientKey: NutrientController], title: String, labelLength: Int = 3, spacing: CGFloat = 8, barWidth: CGFloat = 12, height: CGFloat = 100) {
        self.nutrients = nutrients
        self.title = title
        self.labelLength = labelLength
        self.spacing = spacing
        self.barWidth = barWidth
        self.height = height
    }
    
    var body: some View {
        BarChart(nutrients: nutrients, title: title, labelLength: labelLength, spacing: spacing, barWidth: barWidth, height: height) {
            HStack(spacing: 0) {
                Group {
                    if let a = nutrients[.a] { Bar(nutrient: a, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let c = nutrients[.c] { Bar(nutrient: c, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let e = nutrients[.e] { Bar(nutrient: e, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let k = nutrients[.k] { Bar(nutrient: k, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                }
                Group {
                    if let b1 = nutrients[.b1] { Bar(nutrient: b1, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let b2 = nutrients[.b2] { Bar(nutrient: b2, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let b3 = nutrients[.b3] { Bar(nutrient: b3, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let b6 = nutrients[.b6] { Bar(nutrient: b6, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let b9 = nutrients[.b9] { Bar(nutrient: b9, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let b12 = nutrients[.b12] { Bar(nutrient: b12, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                    if let choline = nutrients[.choline] { Bar(nutrient: choline, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                }
            }
        }
    }
}
