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
    
    var body: some View {
        HStack {
            icon
                .foregroundColor(iconColor)
                .font(.title2)
                .padding(.trailing, padding)
            VStack(alignment: HorizontalAlignment.leading) {
                Text(name)
                Text(calories)
                    .font(.system(size: fontSize))
            }
            Spacer()
        }
    }
    
    // MARK: - Drawing Constants
    private let iconColor = Color.accentColor
    private let padding: CGFloat = 8
    private let fontSize: CGFloat = 12
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(name: "Apple", calories: "124 kcal", icon: Image(systemName: "paperplane"))
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
            .padding()
    }
}
