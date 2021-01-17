//
//  PageIndex.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-24.
//

import SwiftUI

struct PageIndex: View {
    
    let numberOfPages: Int
    let currentIndex: Int
    
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages) { index in
                if numberOfPages > 1 {
                    Circle()
                        .fill(currentIndex == index ? primaryColor : secondaryColor)
                        .frame(width: circleSize, height: circleSize)
                        .transition(AnyTransition.opacity.combined(with: .scale))
                        .id(index)
                }
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let circleSize: CGFloat = 10
    private let circleSpacing: CGFloat = 10
    private let primaryColor = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    private let secondaryColor = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.6)
}

struct PageIndex_Previews: PreviewProvider {
    static var previews: some View {
        PageIndex(numberOfPages: 5, currentIndex: 2)
    }
}
