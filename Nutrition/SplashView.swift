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
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
            Text("DAILY NUTRITION")
                .opacity(textOpacity)
                .animation(Animation.linear(duration: 0.5))
        }
        .onAppear { textOpacity = 1 }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
