//
//  CreateMeal.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-26.
//

import SwiftUI

struct CreateMeal: View {    
    let foodStorage: FoodStorageController
    
    @Binding var name: String
    @Binding var category: Int
    @Binding var ingredients: [Ingredient]
    
    @State private var isIngredientPickerPresented = false
    
    init(name: Binding<String>, category: Binding<Int>, ingredients: Binding<[Ingredient]>, foodStorage: FoodStorageController) {
        _name = name
        _category = category
        _ingredients = ingredients
        self.foodStorage = foodStorage
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                Group {
                    TextField("Enter Name...", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top)
                    
                    categorySegment
                                        
                    Text("Ingredients")
                        .font(.system(size: fontSize, weight: .medium, design: .rounded))
                }
                .padding(.horizontal)
                .padding(.top, paddingTop)
                
                VStack(alignment: .leading, spacing: listSpacing) {
                    IngredientList(ingredients: $ingredients)
                    DefaultButton(title: "Add Ingredient") { isIngredientPickerPresented = true }                    
                        .padding()
                }
            }
        }
        .sheet(isPresented: $isIngredientPickerPresented) { ingredientPicker }
    }
    
    var ingredientPicker: some View {
        IngredientPicker(foodStorage: foodStorage) { foodController, amount in
            let ingredient = NewIngredient(id: UUID(), amount: amount, sortOrder: Int16(ingredients.count),
                                           food: foodController.food, nutritionProfile: foodController.profile)
            ingredients.append(ingredient)
        }
    }
    
    var categorySegment: some View {
        Picker(selection: $category, label: Text("Category")) {
            Text("Breakfast").tag(0)
            Text("Lunch").tag(1)
            Text("Dinner").tag(2)
            Text("Snack").tag(3)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Drawing Constants
    private let spacing: CGFloat = 12
    private let listSpacing: CGFloat = 4
    private let paddingTop: CGFloat = 10
    private let fontSize: CGFloat = 18
    
}

struct IngredientList: View {
    @Binding var ingredients: [Ingredient]
    
    var body: some View {
        ForEach(ingredients, id:\.id) { ingredient in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(rowBackgroundColor)
                    .frame(height: rowHeight)
                HStack {
                    Text("\(ingredient.amount)g    \t")
                        .padding(.leading)
                        .font(.system(size: primaryFontSize, weight: .medium, design: .rounded))
                    Text("\(ingredient.food.name)")
                        .font(.system(size: secondaryFontSize, weight: .light, design: .rounded))
                }
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let rowHeight: CGFloat = 40
    private let primaryFontSize: CGFloat = 16
    private let secondaryFontSize: CGFloat = 14
    private let rowBackgroundColor = Color(#colorLiteral(red: 0.9537998028, green: 0.9537998028, blue: 0.9537998028, alpha: 1))
}

struct CreateMeal_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeal(name: Binding.constant("Smoothie"), category: Binding.constant(0), ingredients: Binding.constant([]), foodStorage: PreviewData.foodStorage)
    }
}
