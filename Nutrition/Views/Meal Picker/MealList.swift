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
        ScrollView {
            VStack {
                ForEach(mealStorage.meals) { mealController in
                    Row(name: mealController.name, calories: mealController.caloriesText, icon: Image.icon(mealController.category)) {
                        MealDetail(mealController: mealController) {
                            $0.eat { self.presentationMode.wrappedValue.dismiss() }                            
                        }
                    }.contextMenu(ContextMenu(menuItems: {
                        Button(action: {
                            mealController.eat { presentationMode.wrappedValue.dismiss() }
                        }, label: { Label("Eat", systemImage: "folder") })
                        Button(action: { mealController.delete() }, label: { Label("Delete", systemImage: "folder") })
                    }))
                }.onDelete { indexSet in mealStorage.deleteMeal(atOffsets: indexSet) }
            }
            Spacer()
        }
    }
}
