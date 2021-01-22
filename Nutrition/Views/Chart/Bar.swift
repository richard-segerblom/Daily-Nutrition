//
//  Bar.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-15.
//

import SwiftUI

struct Bar: View {
    let nutrient: NutrientController
    
    let size: CGSize
    let padding: CGFloat
    let labelLength: Int
    
    @Binding var selected: NutrientKey
    @Binding var lastSelected: NutrientKey
    @Binding var timer: Timer?
    
    init(nutrient: NutrientController, size: CGSize, padding: CGFloat = 5, labelLength: Int = 3,
         selected: Binding<NutrientKey>, lastSelected: Binding<NutrientKey>, timer: Binding<Timer?>) {
        self.nutrient = nutrient
        self.size = size
        self.padding = padding
        self.labelLength = labelLength
        _selected = selected
        _lastSelected = lastSelected
        _timer = timer
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: spacing) {
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: size.width, height: size.height)
                        .foregroundColor(trackColor)
                    Rectangle().frame(width: size.width, height: height)
                        .foregroundColor(progressColor)
                        .animation(Animation.linear.delay(0.3))
                }
                .padding(.horizontal, padding)
                
                Text(nutrient.name.prefix(labelLength))
                    .font(.system(size: fontSize))
                    .foregroundColor(textColor)
            }
        }
        .zIndex(selected == nutrient.key || lastSelected == nutrient.key ? 2 : 1 )
        .onTapGesture {
            lastSelected = nutrient.key
            selected = selected == nutrient.key ? .none : nutrient.key
            if let timer = timer { timer.invalidate() }
            if selected != .none {
                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in self.selected = .none })
            }
        }
        .overlay(
            BarDetail(color: progressColor, text: nutrient.progressText)
                .offset(x: 0, y: detailY)
                .fixedSize()
                .opacity(selected == nutrient.key ? 1 : 0)
                .animation(Animation.linear)
        )
    }
    
    // MARK: - Drawing Constants
    private let trackColor: Color = Color("TrackColor")
    private let progressColor = Color("PrimaryColor")
    private let textColor: Color = Color("PrimaryTextColor")
    private var height: CGFloat { CGFloat(nutrient.limitProgress) * size.height }
    private let spacing: CGFloat = 8
    private let fontSize: CGFloat = 12
    private var detailY: CGFloat { -size.height/2 }
}

struct BarDetail: View {    
    var color: Color
    var text: String
    
    init(color: Color, text: String) {
        self.color = color
        self.text = text
    }
    
    @ViewBuilder
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(height: height)
                .foregroundColor(color)
                .shadow(color: shadowColor, radius: 2, x: 0, y: 0)
            Text(text)
                .font(.system(size: fontSize))
                .padding(.horizontal, padding)
                .foregroundColor(textColor)
        }
    }
    
    // MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 5
    private let textColor = Color("SecondaryTextColor")
    private let shadowColor = Color("PrimaryColor")
    private var height: CGFloat { isIpadTouch ? 20 : 23 }
    private var padding: CGFloat { isIpadTouch ? 4 : 6 }
    private var fontSize: CGFloat { isIpadTouch ? 12 : 16 }
    private var isIpadTouch: Bool { UIScreen.main.bounds.size.width < 400 }
}
