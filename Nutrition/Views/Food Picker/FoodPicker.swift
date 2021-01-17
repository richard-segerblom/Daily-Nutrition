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

struct FoodPicker_Previews: PreviewProvider {
    static var previews: some View {
        FoodPicker(foodStorage: PreviewData.foodStorage)
    }
}
