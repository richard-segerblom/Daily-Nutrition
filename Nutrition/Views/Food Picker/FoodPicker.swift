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
            FoodList(foodStorage: foodStorage, action: eatTapped(food:amount:))
        }
    }
    
    func eatTapped(food: FoodController, amount: Int16) {
        food.eat(amount: amount) { self.presentationMode.wrappedValue.dismiss() }
    }
}

struct FoodList: View {
    @ObservedObject var foodStorage: FoodStorageController
    @State private var isSearchPresented: Bool = false
        
    let style: PickerStyle
    let action: (FoodController, Int16) -> Void
    let searchController: SearchController
    
    var foods: [FoodController] { foodStorage.foods }
    
    init(foodStorage: FoodStorageController, style: PickerStyle = .food, action: @escaping (FoodController, Int16) -> Void) {
        self.foodStorage = foodStorage
        self.style = style
        self.action = action
        self.searchController = SearchController(required: foodStorage.userController.profile,
                                                 persistenceController: foodStorage.persistenceController)
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        List {
            Section(header: Label("ALL", systemImage: "asterisk.circle")) {
                ForEach(foods) { foodController in
                    NavigationLink(destination: FoodDetail(foodController: foodController, style: style, action: action)) {
                        FoodRow(foodController: foodController)
                    }
                }
            }
        }
        .sheet(isPresented: $isSearchPresented) { SearchView(searchController: searchController) }
        .navigationTitle("Eat Something?")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                if style == .food { Button(action: { isSearchPresented = true }, label: { Text("New") }) }
                else { EmptyView() }
            }
            ToolbarItem(placement: .navigationBarTrailing) { menu }
        }
    }
    
    var menu: some View {
        Menu {
            // TODO Implement filter
            Button(action: { }, label: { Label("All", systemImage: "folder") })
            Button(action: { }, label: { Label("Fruits", systemImage: "folder") })
            Button(action: { }, label: { Label("Vegetables", systemImage: "folder") })
            Button(action: { }, label: { Label("Nuts", systemImage: "folder") })
            Button(action: { }, label: { Label("Legumes", systemImage: "folder") })
            Button(action: { }, label: { Label("Grains", systemImage: "folder") })
            Button(action: { }, label: { Label("Other", systemImage: "folder") })
        } label: {
            Text("Filter").foregroundColor(menuColor)
        }
    }
    
    // MARK: - Drawing Constants
    private let menuColor = Color("ProgressColor")
}

struct FoodPicker_Previews: PreviewProvider {
    static var previews: some View {
        FoodPicker(foodStorage: PreviewData.foodStorage)
    }
}
