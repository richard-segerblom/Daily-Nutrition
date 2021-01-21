//
//  DefaultButton.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-26.
//

import SwiftUI

struct DefaultButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    init(title: String, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(backgroundColor)
                Text(title)
                    .font(.system(size: fontSize))
                    .foregroundColor(.white)
            }
        }
        .frame(height: height)
        .disabled(isDisabled)
    }
    
    // MARK: - Drawing Constants
    private let fontSize: CGFloat = 26
    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 50
    private let color = Color("ProgressColor")
    private let disabledColor = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    var backgroundColor: Color { isDisabled ? disabledColor : color }
}

struct ButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(title: "EAT", action: { })
            .previewLayout(PreviewLayout.fixed(width: 400, height: 100))
            .padding()
    }
}
