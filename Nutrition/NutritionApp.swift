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
    
    init() {
        guard let appController = AppController() else {  fatalError("AppController initialization failed") }
        self.appController = appController
    }
    
    var body: some Scene {
        WindowGroup {
            if appController.isContentLoaded {
                Home(app: appController)
            }
            else {
                Text("Loading...")
            }
        }
    }
}
