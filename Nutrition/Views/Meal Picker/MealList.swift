//
//  MealList.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-16.
//

import SwiftUI

struct MealList: View {
    @ObservedObject var mealStorage: MealStorageController
    @Binding var filter: MealFilterOption
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(mealStorage.meals) { mealController in
                NavigationLink(destination: MealDetail(mealController: mealController) {
                    $0.eat()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    MealRow(mealController: mealController)
                        .contextMenu(ContextMenu(menuItems: {
                            eatButton
                            deleteButton
                        }))
                }
            }
            .onDelete { indexSet in mealStorage.deleteMeal(atOffsets: indexSet) }
        }
    }
    
    var eatButton: some View {
        Button(action: { /* TODO Implement eat */ }, label: { Label("Eat", systemImage: "folder") })
    }
    
    var deleteButton: some View {
        Button(action: { /* TODO Implement delete */ }, label: { Label("Delete", systemImage: "folder") })
    }
}
