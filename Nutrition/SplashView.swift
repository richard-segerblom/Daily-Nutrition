//
//  SplashView.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-15.
//

import SwiftUI

struct SplashView: View {
    @State var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 5) {
                Text("Nutritional Health")
                    .opacity(textOpacity)
                    .foregroundColor(titleColor)
                    .animation(Animation.linear(duration: 0.5))
                    .padding(.horizontal)
                Text("Whole-Foods, Plant Based Diet")
                    .opacity(textOpacity)
                    .foregroundColor(subTitleColor)
                    .animation(Animation.linear(duration: 0.5))
                    .padding(.horizontal)
                    .font(.subheadline)
            }
        }
        .onAppear { textOpacity = 1 }
    }
    
    // MARK: - Drawing Constants
    private let titleColor = Color("PrimaryColor")
    private let subTitleColor = Color("PrimaryTextColor")
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
