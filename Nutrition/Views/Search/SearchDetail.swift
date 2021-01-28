//
//  SearchDetail.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-30.
//

import SwiftUI

struct SearchDetail: View {
    let profile: FoodController
    
    @State private var isSavePromptPresented = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Detail(profile: profile)
                    .padding()
                DefaultButton(title: "ADD", action: { isSavePromptPresented = true })
                    .padding()
            }
            .navigationTitle(profile.name)
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isSavePromptPresented = true }) { Text("Add") } }
            }
            
            if isSavePromptPresented {
                SavePrompt(profile: profile, isSavePromptPresented: $isSavePromptPresented)
            }
        }
    }
}

struct SavePrompt: View {
    let profile: FoodController
    
    @State private var name: String = ""
    @State private var category = 0
    
    @Binding var isSavePromptPresented: Bool
    
    init(profile: FoodController, isSavePromptPresented: Binding<Bool>) {
        self.profile = profile
        _isSavePromptPresented = isSavePromptPresented
        name = profile.name
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                TextField("Food Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, padding)
                
                FoodCategoryPicker(selected: $category)
                
                HStack(spacing: spacing) {
                    Button(action: { self.isSavePromptPresented = false }, label: { Text("Cancel") })
                    Button(action: { self.isSavePromptPresented = false
                            debugPrintFoodToJSONObject(name: name, category: category, profile: profile) },
                           label: { Text("Save") })
                }.padding(.top, padding)
            }.padding()
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
        .shadow(radius: shadowRadius)
        .zIndex(2)
    }
    
    // MARK: - Drawing Constants
    private let padding: CGFloat = 10
    private let spacing: CGFloat = 40
    private let width: CGFloat = 300
    private let height: CGFloat = 150
    private let cornerRadius: CGFloat = 20
    private let shadowRadius: CGFloat = 20
}

struct FoodCategoryPicker: View {
    @Binding var selected: Int
    
    var body: some View {
        // TODO show icons instead of text
        Picker("Category", selection: $selected) {
            Text("Fruit").tag(0)
            Text("Vegetables").tag(1)
            Text("Nuts").tag(2)
            Text("Legumes").tag(3)
            Text("Grains").tag(4)
            Text("Animal").tag(5)            
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct SearchDetail_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetail(profile: PreviewData.foodController)
    }
}

/*
 
 menuItem(name: "All", icon: "asterisk.circle.fill", filter: .all)
 menuItem(name: "Fruits", icon: "f.circle.fill", filter: .fruit)
 menuItem(name: "Vegetables", icon: "v.circle.fill", filter: .vegetables)
 menuItem(name: "Nuts", icon: "n.circle.fill", filter: .meat)
 menuItem(name: "Legumes", icon: "l.circle.fill", filter: .meat)
 menuItem(name: "Grains", icon: "g.circle.fill", filter: .meat)
 menuItem(name: "Meat", icon: "m.circle.fill", filter: .meat)
 menuItem(name: "Seafood", icon: "s.circle.fill", filter: .seafood)
 menuItem(name: "Dairy", icon: "d.circle.fill", filter: .dairy)
 menuItem(name: "Pantry", icon: "p.circle.fill", filter: .pantry)
 
 */


// ---------------------------------- REMOVE -----------------------------------
func debugPrintFoodToJSONObject(name: String, category: Int, profile: FoodController) {
    print("{\"Food Name\": \"\(name)\", \"Category\": \(category),")
    print("\"Nutrients\": [")
    for (key, value) in profile.food.profile.nutrients {
        if key == .unknown { continue }
        if value.value == 0 { continue }
        print("{\"Key\": \"\(value.key.rawValue)\", \"Unit\": \"\(value.unit.rawValue)\", \"Value\": \(value.value)}, ")
    }
    print("]}")
}
// ------------------------------------ END ------------------------------------
