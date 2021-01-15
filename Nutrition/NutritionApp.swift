//
//  NutritionApp.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import SwiftUI

@main
struct NutritionApp: App {
    let persistenceController = PersistenceController.shared

    @ObservedObject var appController: AppController
    
    @State var showSplash = true
    
    init() {
        guard let appController = AppController() else {  fatalError("AppController initialization failed") }
        self.appController = appController
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appController.isContentLoaded {
                    Home(app: appController)
                        .onAppear { showSplash = false }
                }
                                
                SplashView()
                    .opacity(showSplash ? 1 : 0)                    
                    .animation(Animation.linear(duration: 0.5).delay(0.5))
            }
        }
    }
}
