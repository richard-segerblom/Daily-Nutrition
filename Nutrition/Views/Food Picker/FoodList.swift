//
//  FoodList.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2021-01-17.
//

import SwiftUI

struct FoodList: View {
    @ObservedObject var foodStorage: FoodStorageController
    
    @State private var filterOption: FoodFilterOption = .all
    @State private var isSearchPresented: Bool = false
    @State var selection: Int? = nil
    
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
        List(foodStorage.foods) { foodController in
            NavigationLink(
                destination: FoodDetail(foodController: foodController, style: style, action: action),
                label: {
                    Row(name: foodController.name, calories: foodController.caloriesText, icon: Image.icon(foodController.category))
                })
        }
        .sheet(isPresented: $isSearchPresented) { SearchView(searchController: searchController) }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            /* TODO Remove Search
            ToolbarItem(placement: .navigationBarLeading) {
                if style == .food { Button(action: { isSearchPresented = true }, label: { Text("New") }) }
                else { Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: { Text("Close") }) }
            }
             */
            ToolbarItem(placement: .navigationBarTrailing) { menu }
        }
    }
    
    var menu: some View {
        Menu {
            menuItem(name: "All", icon: "asterisk.circle.fill", filter: .all)
            menuItem(name: "Fruits", icon: "f.circle.fill", filter: .fruit)
            menuItem(name: "Vegetables", icon: "v.circle.fill", filter: .vegetables)
            menuItem(name: "Nuts", icon: "n.circle.fill", filter: .nuts)
            menuItem(name: "Legumes", icon: "l.circle.fill", filter: .legumes)
            menuItem(name: "Grains", icon: "g.circle.fill", filter: .grains)
            menuItem(name: "Animal", icon: "a.circle.fill", filter: .animal)
        } label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(menuColor)
                .font(.system(size: navigationBarIconSize))
        }
    }
    
    func menuItem(name: String, icon: String, filter: FoodFilterOption) -> some View {
        Button(action: {
            filterOption = filter
            foodStorage.filter(filter)
        }, label: {
            Label(name, systemImage: icon)
        })
    }
    
    // MARK: - Drawing Constants
    private let menuColor = Color("PrimaryColor")
    private let navigationBarIconSize: CGFloat = 26
}
