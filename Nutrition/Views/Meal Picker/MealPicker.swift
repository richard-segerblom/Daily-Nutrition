//
//  MealPicker.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-25.
//

import SwiftUI

struct MealPicker: View {
    @ObservedObject var mealStorage: MealStorageController
    var foodStorage: FoodStorageController
    
    @State private var filterOption: MealFilterOption = .all
    @State private var isCreateMealPresented = false       
    
    init(mealStorage: MealStorageController, foodStorage: FoodStorageController) {
        self.mealStorage = mealStorage
        self.foodStorage = foodStorage
        
        filterOption = mealStorage.isRecentEmpty ? .recent : .all
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            Group {
                if mealStorage.meals.isEmpty {
                   createMealButton
                } else if filterOption == .recent {
                   
                } else {
                   MealList(mealStorage: mealStorage)
                }
            }
            .navigationTitle("Meals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) { menu }
                ToolbarItem(placement: .navigationBarLeading) { addButton }
            }
        }.sheet(isPresented: $isCreateMealPresented) {
            CreateMeal(mealStorage: mealStorage, foodStorage: foodStorage)
        }
    }                       
        
    var addButton: some View { Button(action: { isCreateMealPresented = true }, label: { Image(systemName: "plus") }) }
    
    var createMealButton: some View {
        Button(action: {
            isCreateMealPresented = true
        }, label: {
            VStack {
                Text(mealStorage.description(filterOption))
                    .multilineTextAlignment(.center)
            }.foregroundColor(.accentColor)
        })
    }
    
    var menu: some View {
        Menu {
            menuItem(name: "Recent", icon: "folder", filter: .recent)
            menuItem(name: "All", icon: "folder", filter: .all)
            menuItem(name: "Breakfast", icon: "folder", filter: .breakfast)
            menuItem(name: "Lunch", icon: "folder", filter: .lunch)
            menuItem(name: "Dinner", icon: "folder", filter: .dinner)
            menuItem(name: "Snack", icon: "folder", filter: .snack)
        } label: {
            Image(systemName: "slider.horizontal.3").foregroundColor(menuColor)
        }
    }
    
    func menuItem(name: String, icon: String, filter: MealFilterOption) -> some View {
        Button(action: {
            filterOption = filter
            mealStorage.filter(filter)
        }, label: { Label(name, systemImage: icon) })
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
