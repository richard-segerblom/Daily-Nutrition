//
//  CreateMeal.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-26.
//

import SwiftUI

struct CreateMeal: View {
    let mealStorage: MealStorageController
    let foodStorage: FoodStorageController
    
    @State private var name: String = ""
    @State private var category: Int = 0
    @State private var ingredients: [Ingredient] = []
    
    @State private var isIngredientPickerPresented = false
    @State private var isNutritonProfilePresented = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(mealStorage: MealStorageController, foodStorage: FoodStorageController) {
        self.mealStorage = mealStorage
        self.foodStorage = foodStorage
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: spacing) {
                        Group {
                            nameTextField
                            categorySegment
                            HStack {
                                Text("Ingredients")
                                    .font(.system(size: fontSize, weight: .medium, design: .rounded))
                                addIngredientButton
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, paddingTop)
                        
                        VStack(alignment: .leading, spacing: listSpacing) {
                            if ingredients.isEmpty { noIngredientsText }
                            IngredientList(ingredients: $ingredients)
                            createButton
                                .padding()
                        }.foregroundColor(Color(#colorLiteral(red: 0.3985456812, green: 0.3985456812, blue: 0.3985456812, alpha: 1)))
                    }
                }
                .navigationTitle("Create Meal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar() {
                    ToolbarItem(placement: .navigationBarLeading) { leadingButton }
                    ToolbarItem(placement: .navigationBarTrailing) { trailingButton }
                }
                                
                NavigationLink( destination: mealDetails, isActive: $isNutritonProfilePresented, label: { EmptyView() })
                
            }
        }.sheet(isPresented: $isIngredientPickerPresented) { ingredientPicker }
    }
    
    var noIngredientsText: some View {
        Text("No ingredeint..")
            .font(.subheadline)
            .padding()
    }
    
    var nameTextField: some View {
        TextField("Enter Name...", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.top)
    }
    
    var mealDetails: CreateMealDetail {
        CreateMealDetail(profile: MealStorageController.nutrition(ingredients, user: mealStorage.userController))
    }
    
    var leadingButton: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: { Text("Cancel") })
    }
    
    var trailingButton: some View {
        Button(action: { self.isNutritonProfilePresented = true }, label: { Image(systemName: "info") })
    }
    
    var addIngredientButton: some View {
        Button(action: { isIngredientPickerPresented = true }, label: { Image(systemName: "plus.circle.fill") })
            .foregroundColor(.accentColor)
            .font(.system(size: iconSize))
    }
    
    var createButton: some View {
        DefaultButton(title: "CREATE", isDisabled: ingredients.isEmpty) {
            self.presentationMode.wrappedValue.dismiss()
            mealStorage.createMeal(name: name, category: category, ingredients: ingredients)
        }
    }
    
    var ingredientPicker: some View {
        IngredientPicker(foodStorage: foodStorage) { foodController, amount in
            let ingredient = NewIngredient(id: UUID(), amount: amount, sortOrder: Int16(ingredients.count), food: foodController.food)
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
    private let iconSize: CGFloat = 24
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

struct CreateMealDetail: View {
    let profile: NutritionProfileController
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Detail(profile: profile)
        }
        .padding()
    }
}

struct CreateMeal_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeal(mealStorage: PreviewData.mealStorage, foodStorage: PreviewData.foodStorage)
    }
}
