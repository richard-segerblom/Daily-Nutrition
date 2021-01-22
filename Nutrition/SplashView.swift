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
            Text("DAILY NUTRITION")
                .opacity(textOpacity)
                .foregroundColor(textColor)
                .animation(Animation.linear(duration: 0.5))
                .multilineTextAlignment(.center)
        }
        .onAppear { textOpacity = 1 }
    }
    
    // MARK: - Drawing Constants
    private let textColor = Color("PrimaryColor")
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
