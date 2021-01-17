//
//  FoodPicker.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-17.
//

import SwiftUI

enum PickerStyle: String {
    case food = "EAT"
    case ingredient = "ADD"
}

struct FoodPicker: View {    
    @ObservedObject var foodStorage: FoodStorageController
    @Environment(\.presentationMode) var presentationMode
    
    init(foodStorage: FoodStorageController) {
        self.foodStorage = foodStorage
                
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            FoodList(foodStorage: foodStorage, title: "Eat Something?", action: eatTapped(food:amount:))
        }
    }
    
    func eatTapped(food: FoodController, amount: Int16) {
        food.eat(amount: amount) { self.presentationMode.wrappedValue.dismiss() }
    }
}

struct FoodList: View {
    @ObservedObject var foodStorage: FoodStorageController
    
    @State private var filterOption: FoodFilterOption = .all
    @State private var isSearchPresented: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
        
    let style: PickerStyle
    let action: (FoodController, Int16) -> Void
    let searchController: SearchController
    let title: String        
    
    init(foodStorage: FoodStorageController, title: String, style: PickerStyle = .food, action: @escaping (FoodController, Int16) -> Void) {
        self.foodStorage = foodStorage
        self.title = title
        self.style = style
        self.action = action
        self.searchController = SearchController(required: foodStorage.userController.profile,
                                                 persistenceController: foodStorage.persistenceController)
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        List {            
            ForEach(foodStorage.foods) { foodController in
                NavigationLink(destination: FoodDetail(foodController: foodController, style: style, action: action)) {
                    FoodRow(foodController: foodController)
                }
            }
        }
        .sheet(isPresented: $isSearchPresented) { SearchView(searchController: searchController) }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                if style == .food { Button(action: { isSearchPresented = true }, label: { Text("New") }) }
                else { Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: { Text("Close") }) }
            }
            ToolbarItem(placement: .navigationBarTrailing) { menu }
        }
    }
    
    var menu: some View {
        Menu {
            menuItem(name: "All", icon: "asterisk.circle.fill", filter: .all)
            menuItem(name: "Fruits", icon: "f.circle.fill", filter: .fruit)
            menuItem(name: "Vegetables", icon: "v.circle.fill", filter: .vegetables)
            menuItem(name: "Meat", icon: "m.circle.fill", filter: .meat)
            menuItem(name: "Seafood", icon: "s.circle.fill", filter: .seafood)
            menuItem(name: "Dairy", icon: "d.circle.fill", filter: .dairy)
            menuItem(name: "Pantry", icon: "p.circle.fill", filter: .pantry)  
        } label: {
            Image(systemName: "slider.horizontal.3").foregroundColor(menuColor)
        }
    }
    
    func menuItem(name: String, icon: String, filter: FoodFilterOption) -> some View {
        Button(action: {
            filterOption = filter
            foodStorage.filter(filter)
        }, label: { Label(name, systemImage: icon) })
    }
    
    // MARK: - Drawing Constants
    private let menuColor = Color("ProgressColor")
}

struct FoodPicker_Previews: PreviewProvider {
    static var previews: some View {
        FoodPicker(foodStorage: PreviewData.foodStorage)
    }
}
