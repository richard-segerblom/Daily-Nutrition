//
//  DefaultButton.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-26.
//

import SwiftUI

struct DefaultButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    init(title: String, action: @escaping () -> Void, color: Color = Color("ProgressColor")) {
        self.title = title
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(color)
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .frame(height: height)
    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 50
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(title: "EAT", action: { })
            .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
            .padding()
    }
}
