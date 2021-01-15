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
    
    @State private var isDetailPresented = false
    @State private var timer: Timer?
    @State private var zIndex = 0
    @State private var progress: CGFloat = 0
    
    init(nutrient: NutrientController, size: CGSize, padding: CGFloat = 5, labelLength: Int = 3) {
        self.nutrient = nutrient
        self.size = size
        self.padding = padding
        self.labelLength = labelLength                
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: spacing) {
                ZStack(alignment: .bottom) {
                    Rectangle().frame(width: size.width, height: size.height)
                        .foregroundColor(progressTrackColor)
                    Rectangle().frame(width: size.width, height: progress)
                        .foregroundColor(progressColor)
                        .animation(Animation.linear)
                }
                .padding(.horizontal, padding)
                Text(nutrient.name.prefix(labelLength))
                    .font(.system(size: fontSize))
                    .foregroundColor(textColor)
            }.onTapGesture {
                isDetailPresented = !isDetailPresented
                if isDetailPresented {
                    if let timer = timer { timer.invalidate() }
                    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        self.isDetailPresented = false
                    })
                }
            }.overlay(
                BarDetail(isPresented: $isDetailPresented, color: progressColor, text: nutrient.progressText)
                    .offset(x: 0, y: detailY)
                    .fixedSize()
                    .animation(Animation.linear(duration: fadeInOutSpeed))
            )
        }.zIndex(isDetailPresented ? 2 : 0)
        .onAppear {
            progress = height
        }
    }
    
    // MARK: - Drawing Constants
    private let progressTrackColor: Color = Color("ProgressTrackColor")
    private let progressColor: Color = Color("ProgressColor")
    private let textColor: Color = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    private var height: CGFloat { CGFloat(nutrient.limitProgress) * size.height }
    private let spacing: CGFloat = 8
    private let fontSize: CGFloat = 12
    private var detailY: CGFloat { -size.height/2 }
    private let fadeInOutSpeed: Double = 0.05
}

struct BarDetail: View {
    @Binding var isPresented: Bool
    var color: Color
    var text: String
    
    init(isPresented: Binding<Bool>, color: Color, text: String) {
        _isPresented = isPresented
        self.color = color
        self.text = text
    }
    
    @ViewBuilder
    var body: some View {
        if isPresented {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(height: height)
                    .foregroundColor(color)
                Text(text)
                    .font(.subheadline)
                    .padding(.horizontal, padding)
                    .foregroundColor(textColor)
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let height: CGFloat = 25
    private let cornerRadius: CGFloat = 5
    private let padding: CGFloat = 8
    private let textColor = Color.white
}

struct Bar_Previews: PreviewProvider {
    static var previews: some View {
        Bar(nutrient: PreviewData.nutrientController, size: CGSize(width: 20, height: 150))
            .previewLayout(PreviewLayout.fixed(width: 50, height: 200))
    }
}
