//
//  NutritionApp.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import SwiftUI

@main
struct NutritionApp: App {
    @ObservedObject var appController: AppController
    
    @State var showSplash = true
    
    init() {
        #if DEBUG
        UserDefaults.standard.set(false, forKey: "uitesting")
        if CommandLine.arguments.contains("--uitesting") {
            print("--uitesting")
            let defaultsName = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: defaultsName)
            UserDefaults.standard.set(true, forKey: "uitesting")
        }
        #endif
        
        guard let appController = AppController() else {  fatalError("AppController initialization failed") }
        self.appController = appController
        
        #if DEBUG
        if CommandLine.arguments.contains("-user") {
            print("-user")
            let user = User.makeNewUser(age: 36, gender: .man, persistenceController: appController.persitence)
            appController.user = UserController(persistenceController: appController.persitence, user: user)
        }
        #endif
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
