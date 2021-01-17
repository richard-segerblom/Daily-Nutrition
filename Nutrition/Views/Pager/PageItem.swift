//
//  PageItem.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-24.
//

import SwiftUI

struct PageItem: View {
    let food: FoodController
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image.icon(food.category)
                    .foregroundColor(iconColor)
                    .padding(iconPadding)
                
                VStack(alignment: HorizontalAlignment.leading) {
                    Text(food.name)
                    Text(food[.calories].intValueDetailText)
                        .font(.system(size: subTitleFontSize(geometry)))
                }
                
                Spacer()
                
                Image(systemName: "plus")
                    .foregroundColor(iconColor)
                    .padding()
            }
            .font(.system(size: titleFontSize(geometry)))
            .position(x: x(geometry), y: y(geometry))
            .border(Color.accentColor)
        }
    }
    
    // MARK: - Drawing Constants
    private let iconPadding: CGFloat = 10
    private let iconColor = Color.accentColor
    private func titleFontSize(_ geometry: GeometryProxy) -> CGFloat { 0.07 * geometry.size.width }
    private func subTitleFontSize(_ geometry: GeometryProxy) -> CGFloat { 0.04 * geometry.size.width }
    private func x(_ geometry: GeometryProxy) -> CGFloat { geometry.size.width / 2 }
    private func y(_ geometry: GeometryProxy) -> CGFloat { geometry.size.height / 2 }
}

struct PageItem_Previews: PreviewProvider {
    static var previews: some View {
        PageItem(food: PreviewData.foodController)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 80))
    }
}
