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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
