//
//  CreateMeal.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-26.
//

import SwiftUI

struct CreateMeal: View {
    @ObservedObject var mealController: MealController
    let foodStorage: FoodStorageController
    
    @State private var name = ""
    @State private var category = 0
    @State private var ingredients: [Ingredient] = []    
    
    init(mealController: MealController, foodStorageController: FoodStorageController) {
        self.mealController = mealController
        self.foodStorage = foodStorageController
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            Form {
                CreateMealInfo(name: $name, category: $category)
                CreateMealIngredients(foodStorageController: foodStorage, ingredients: $ingredients)
                CreateMealNutritionSumary(mealController: mealController)
            }
            .navigationTitle("New Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { /* TODO implement create */ }, label: { Text("Create") })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CreateMealInfo: View {
    @Binding var name: String
    @Binding var category: Int
    
    var body: some View {
        Section {
            TextField("Enter Name...", text: $name)
            
            Picker(selection: $category, label: Text("Category")) {
                Text("Breakfast").tag(0)
                Text("Lunch").tag(1)
                Text("Dinner").tag(2)
                Text("Snack").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct CreateMealIngredients: View {
    let foodStorageController: FoodStorageController
    @Binding var ingredients: [Ingredient]
    
    var body: some View {
        Section(header: Text("Ingredients")) {
            List(0...ingredients.count, id: \.self) { index in
                if index < ingredients.count {
                    let ingredient = ingredients[index]
                    HStack {
                        Text("\(ingredient.amount)g\t\(ingredient.food.name)")
                    }
                } else {
                    NavigationLink(destination: FoodList(foodStorage: foodStorageController, style: .ingredient, action: { food, amount in /* TODO Implement add ingredient */ })) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                                .font(.system(size: iconSize))
                                .padding(.trailing, iconPadding)
                            Text("Add Ingredient...")
                        }.foregroundColor(color)
                    }
                }
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let iconSize: CGFloat = 26
    private let iconPadding: CGFloat = 4
    private let color = Color.accentColor
}

struct CreateMealNutritionSumary: View {
    @ObservedObject var mealController: MealController
    
    var body: some View {
        Section(header: Text("Nutriens")) {
            VStack {
                Detail(profile: mealController.nutritionProfile)
                DefaultButton(title: "CREATE", action: { /* TODO Implement create meal */ })
                    .padding(.vertical)
            }
        }
    }
}

struct CreateMeal_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeal(mealController: PreviewData.mealController, foodStorageController: PreviewData.foodStorage)
    }
}
