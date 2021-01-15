//
//  MineralChart.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-15.
//

import SwiftUI

struct MineralChart: View {
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
                if let calcium = nutrients[.calcium] { Bar(nutrient: calcium, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let phosphorus = nutrients[.phosphorus] { Bar(nutrient: phosphorus, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let potassium = nutrients[.potassium] { Bar(nutrient: potassium, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let magnesium = nutrients[.magnesium] { Bar(nutrient: magnesium, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let iron = nutrients[.iron] { Bar(nutrient: iron, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let zinc = nutrients[.zinc] { Bar(nutrient: zinc, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let copper = nutrients[.copper] { Bar(nutrient: copper, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let sodium = nutrients[.sodium] { Bar(nutrient: sodium, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let manganese = nutrients[.manganese] { Bar(nutrient: manganese, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
                if let selenium = nutrients[.selenium] { Bar(nutrient: selenium, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength) }
            }
        }
    }
}
