//
//  BarChart.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-15.
//

import SwiftUI

struct BarChart: View {
    let nutrients: [NutrientController]
    let title: String
    let labelLength: Int
    let spacing: CGFloat
    let barWidth: CGFloat
    let height: CGFloat
    
    init(nutrients: [NutrientController], title: String, labelLength: Int = 3, spacing: CGFloat = 8, barWidth: CGFloat = 12, height: CGFloat = 100) {
        self.nutrients = nutrients
        self.title = title
        self.labelLength = labelLength
        self.spacing = spacing
        self.barWidth = barWidth
        self.height = height
    }
            
    var body: some View {
        VStack(alignment: .center, spacing: verticalSpacing) {
            Text("\(title) - \(NutritionProfileController.totalProgress(nutrients: nutrients), specifier: "%.0f")%")
                .font(.system(size: fontSize))
                .foregroundColor(textColor)
            
            ZStack {
                lineTop
                lineCenter
                lineBottom
                
                HStack(spacing: 0) {
                    ForEach(nutrients) { nutrient in
                        Bar(nutrient: nutrient, size: CGSize(width: barWidth, height: height), padding: spacing, labelLength: labelLength)
                    }
                }
            }
        }
    }
    
    var lineTop: some View {
        BarChartLine(title: "100", lineWidth: lineWidth, lineHeight: lineHeight).offset(x: -16, y: -(height / 2) - 11)
    }

    var lineCenter: some View {
        BarChartLine(title: "50", lineWidth: lineWidth, lineHeight: lineHeight).offset(x: -14, y: -11)
    }
    
    var lineBottom: some View {
        BarChartLine(title: "0", lineWidth: lineWidth, lineHeight: lineHeight).offset(x: -10, y: (height / 2) - 11)
    }
    
    // MARK: - Drawing Constants
    private var lineWidth: CGFloat { max((CGFloat(nutrients.count) * barWidth) + CGFloat(nutrients.count) * ((spacing * 2) - 1), 0) }
    private let lineHeight: CGFloat = 1
    private let verticalSpacing: CGFloat = 4
    private let fontSize: CGFloat = 14
    private let textColor = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
}

struct BarChartLine: View {
    let title: String
    let lineWidth: CGFloat
    let lineHeight: CGFloat
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(textColor)
            Rectangle()
                .frame(width: lineWidth, height: lineHeight)
                .foregroundColor(lineColor)
        }
    }
    
    // MARK: - Drawing Constants
    private let fontSize: CGFloat = 12
    private let textColor = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    private let lineColor = Color(#colorLiteral(red: 0.9247807457, green: 0.9247807457, blue: 0.9247807457, alpha: 1))
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(nutrients: PreviewData.profileController[.vitamins], title: "VITAMINS", spacing: 6, barWidth: 10)
    }
}
