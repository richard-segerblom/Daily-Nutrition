//
//  Row.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-11.
//

import SwiftUI

struct Row: View {
    let name: String
    let calories: String
    let icon: Image
    
    @State var isSelected = false
    
    init(name: String, calories: String, icon: Image) {
        self.name = name
        self.calories = calories
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            icon
                .font(.title2)
                .padding(.trailing, padding)
                .foregroundColor(iconColor)
            
            VStack(alignment: HorizontalAlignment.leading) {
                Text(name)
                Text(calories)
                    .scaledFont(size: caloriesFontSize)
            }
            .foregroundColor(textColor)
        }
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 8
    private let caloriesFontSize: CGFloat = 12
    private let dividerThickness: CGFloat = 0.5
    private let disclosureSize: CGFloat = 14
    private let iconColor = Color.accentColor
    private let textColor = Color("PrimaryTextColor")
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(name: "Apple", calories: "124 kcal", icon: Image(systemName: "paperplane"))
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
