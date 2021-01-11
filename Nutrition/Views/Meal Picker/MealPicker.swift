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
    
    init(mealStorage: MealStorageController, foodStorage: FoodStorageController) {
        self.mealStorage = mealStorage
        self.foodStorage = foodStorage
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Label("ALL", systemImage: "asterisk.circle")) {
                    sectionContent
                    
                    ForEach(mealStorage.meals) { mealController in
                        NavigationLink(destination: MealDetail(mealController: mealController)) {
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
            .onTapGesture { isCreateMealPresented = true }
            .navigationTitle("Meals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() { ToolbarItem(placement: .navigationBarTrailing) { menu } }
            .sheet(isPresented: $isCreateMealPresented) {
                CreateMeal(mealController: mealStorage.emptyMeal(), foodStorageController: foodStorage)
            }
        }
    }
    
    var sectionContent: some View {
        HStack {
            Image(systemName: "plus.square.fill")
                .font(.system(size: fontSize))
                .padding(.trailing, padding)
            Text("New Meal...")
            Spacer()
        }
        .padding(.vertical, padding)
        .foregroundColor(isCreateMealPresented ? .black : .accentColor)
        .contentShape(Rectangle())
    }
    
    var eatButton: some View { Button(action: { /* TODO Implement eat */ }, label: { Label("Eat", systemImage: "folder") }) }
    
    var deleteButton: some View { Button(action: { /* TODO Implement delete */ }, label: { Label("Delete", systemImage: "folder") }) }
    
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

struct MealPicker_Previews: PreviewProvider {
    static var previews: some View {
        MealPicker(mealStorage: PreviewData.mealStorage, foodStorage: PreviewData.foodStorage)
    }
}
