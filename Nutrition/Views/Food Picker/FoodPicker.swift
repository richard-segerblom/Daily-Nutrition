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
    @State private var isSearchPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
        
    let style: PickerStyle
    let action: (FoodController, Int16) -> Void
    let searchController: SearchController
    let title: String
    
    var foods: [FoodController] { foodStorage.foods }
    
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
            ForEach(foods) { foodController in
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
            // TODO Implement filter
            Button(action: { }, label: { Label("All", systemImage: "asterisk.circle.fill") })
            Button(action: { }, label: { Label("Fruits", systemImage: "f.circle.fill") })
            Button(action: { }, label: { Label("Vegetables", systemImage: "v.circle.fill") })
            Button(action: { }, label: { Label("Meat", systemImage: "m.circle.fill") })
            Button(action: { }, label: { Label("Seafood", systemImage: "s.circle.fill") })
            Button(action: { }, label: { Label("Dairy", systemImage: "d.circle.fill") })
            Button(action: { }, label: { Label("Pantry", systemImage: "p.circle.fill") })
        } label: {
            Image(systemName: "slider.horizontal.3").foregroundColor(menuColor)
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
