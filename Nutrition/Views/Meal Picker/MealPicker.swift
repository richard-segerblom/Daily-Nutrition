//
//  MealPicker.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-25.
//

import SwiftUI

struct MealPicker: View {
    @ObservedObject var mealStorage: MealStorageController
    @ObservedObject var foodStorage: FoodStorageController
    
    @State private var filterOption = 0
    @State private var isCreateMealPresented = false
    
    @State private var newMealName: String = ""
    @State private var newMealCategory: Int = 0
    @State private var newMealIngredients: [Ingredient] = []
    
    init(mealStorage: MealStorageController, foodStorage: FoodStorageController) {
        self.mealStorage = mealStorage
        self.foodStorage = foodStorage
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            Group {
                if isCreateMealPresented {
                    CreateMeal(name: $newMealName, category: $newMealCategory, ingredients: $newMealIngredients, foodStorage: foodStorage)
                } else {
                    if mealStorage.meals.isEmpty {
                       createMealButton
                    } else {
                       MealList(mealStorage: mealStorage)
                    }
                }
            }
            .navigationTitle(isCreateMealPresented ? "New Meal" : "Meals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isCreateMealPresented { createButton } else { menu }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isCreateMealPresented { addButton } else { cancelButton }
                }
            }
        }
    }        
            
    var cancelButton: some View { Button(action: { isCreateMealPresented = false }, label: { Text("Cancel") }) }
    
    var createButton: some View { Button(action: {
        isCreateMealPresented = false
        mealStorage.createMeal(name: newMealName, category: newMealCategory, ingredients: newMealIngredients)
    }, label: { Text("Create") }) }
        
    var addButton: some View { Button(action: { isCreateMealPresented = true }, label: { Image(systemName: "plus") }) }
    
    var createMealButton: some View {
        Button(action: {
            isCreateMealPresented = true
        }, label: {
            VStack {
                Text("You have no meals.\nWant to create a new?")
                    .multilineTextAlignment(.center)
            }.foregroundColor(.accentColor)
        })
    }
    
    var menu: some View {
        Menu {
            // TODO Implement filter
            Button(action: { }, label: { Label("All", systemImage: "folder") })
            Button(action: { }, label: { Label("Breakfast", systemImage: "folder") })
            Button(action: { }, label: { Label("Lunch", systemImage: "folder") })
            Button(action: { }, label: { Label("Dinner", systemImage: "folder") })
            Button(action: { }, label: { Label("Snack", systemImage: "folder") })
        } label: {
            Text("Filter").foregroundColor(menuColor)
        }
    }
    
    // MARK: - Drawing Constants
    private let menuColor = Color("ProgressColor")
    private let padding: CGFloat = 4
    private let fontSize: CGFloat = 26
}

struct MealList: View {
    @ObservedObject var mealStorage: MealStorageController
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section(header: Label("ALL", systemImage: "asterisk.circle")) {
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
    }
    
    var eatButton: some View { Button(action: { /* TODO Implement eat */ }, label: { Label("Eat", systemImage: "folder") }) }
    
    var deleteButton: some View { Button(action: { /* TODO Implement delete */ }, label: { Label("Delete", systemImage: "folder") }) }
}

struct MealPicker_Previews: PreviewProvider {
    static var previews: some View {
        MealPicker(mealStorage: PreviewData.mealStorage, foodStorage: PreviewData.foodStorage)
    }
}
