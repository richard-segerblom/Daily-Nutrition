//
//  ProgressBar.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-11-30.
//

import SwiftUI

struct ProgressBar: View {
    let progress: CGFloat
    
    init(progress: CGFloat) {
        self.progress = progress
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(progressTrackColor)
                Rectangle().frame(width: min(CGFloat(self.progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(progressColor)
            }.cornerRadius(cornerRadius)
        }.padding(0)
    }
    
    // MARK: - Drawing Constants
    private let progressTrackColor: Color = Color("ProgressTrackColor")
    private let progressColor: Color = Color("ProgressColor")
    private let cornerRadius: CGFloat = 6
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.5)
            .previewLayout(PreviewLayout.fixed(width: 300, height: 50))
            .frame(width: 300, height: 20)
    }
}
