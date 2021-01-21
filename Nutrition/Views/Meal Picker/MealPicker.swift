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
                   MealList(mealStorage: mealStorage, filter: $filterOption)
                }
            }
            .navigationTitle(filterOption.rawValue)
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
                description
                    .multilineTextAlignment(.center)
            }.foregroundColor(.accentColor)
        })
    }
    
    var menu: some View {
        Menu {
            menuItem(name: "Recent", icon: "clock.arrow.circlepath", filter: .recent)
            menuItem(name: "All", icon: "asterisk.circle.fill", filter: .all)
            menuItem(name: "Breakfast", icon: "b.circle.fill", filter: .breakfast)
            menuItem(name: "Lunch", icon: "l.circle.fill", filter: .lunch)
            menuItem(name: "Dinner", icon: "d.circle.fill", filter: .dinner)
            menuItem(name: "Snack", icon: "s.circle.fill", filter: .snack)
        } label: {
            Image(systemName: "slider.horizontal.3").foregroundColor(menuColor)
                .font(.system(size: navigationBarIconSize))
        }
    }
    
    var description: some View {
        switch filterOption {
        case .recent:
            return Text("Meals you have eaten will be shown here")
        case .breakfast:
            return Text("You have no breakfast meals.\nDo you want to create one?")
        case .lunch:
            return Text("You have no lunch meals.\nDo you want to create one?")
        case .dinner:
            return Text("You have no dinner meals.\nDo you want to create one?")
        case .snack:
            return Text("You have no snacks.\nDo you want to create one?")
        default:
            return Text("You have no meals.\nDo you want to create one?")
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
    private let navigationBarIconSize: CGFloat = 26
}

struct MealPicker_Previews: PreviewProvider {
    static var previews: some View {
        MealPicker(mealStorage: PreviewData.mealStorage, foodStorage: PreviewData.foodStorage)
    }
}
