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
    
    @State private var timer: Timer?
    @State private var selected: NutrientKey = .none
    @State private var lastSelected: NutrientKey = .none
    
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
                    bar(key: .a)
                    bar(key: .c)
                    bar(key: .e)
                    bar(key: .k)                                       
                }
                Group {
                    bar(key: .b1)
                    bar(key: .b2)
                    bar(key: .b3)
                    bar(key: .b6)
                    bar(key: .b9)
                    bar(key: .b12)
                    bar(key: .choline)
                }
            }
        }
    }
    
    @ViewBuilder
    func bar(key: NutrientKey) -> some View {
        if let nutrient = nutrients[key] {
            Bar(nutrient: nutrient, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength,
                selected: $selected, lastSelected: $lastSelected, timer: $timer)
        }
    }
}
