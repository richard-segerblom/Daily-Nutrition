//
//  ProfileView.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-15.
//

import SwiftUI

struct Profile: View {
    var user: UserController
    
    @State private var profile: NutritionProfileController
        
    @Environment(\.presentationMode) var presentationMode
    
    let url = URL(string: "https://www.dietaryguidelines.gov/sites/default/files/2020-12/Dietary_Guidelines_for_Americans_2020-2025.pdf")
    
    init(user: UserController) {
        self.user = user
        _profile = State(initialValue: NutritionProfileController(profile: user.profile, required: user.profile))
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Spacer()
                    Link("Dietary Guidelines", destination: url!)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                
                ProfileStaticRow(name: "Gender", value: user.genderText)
                ProfileStaticRow(name: "Age", value: "\(user.age)")
                
                ProfileSection(title: "Vitamins", nutrients: profile[.vitamins], profile: $profile)
                ProfileSection(title: "Minerals", nutrients: profile[.minerals], profile: $profile)
                ProfileSection(title: "Energy", nutrients: profile[.energy], profile: $profile, isDecimal: false)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        user.updateNutrients(profile: profile.required)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: { Text("Save") })
                }
            }
        }
    }
}

struct ProfileStaticRow: View {
    let name: String
    let value: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(value)
        }.foregroundColor(textColor)
    }
    
    // MARK: - Drawing Constants
    private let textColor = Color("PrimaryTextColor")
}

struct ProfileSection: View {
    let title: String
    let nutrients: [NutrientController]
    let isDecimal: Bool
    
    @Binding var profile: NutritionProfileController
    
    init(title: String, nutrients: [NutrientController], profile: Binding<NutritionProfileController>, isDecimal: Bool = true) {
        self.title = title
        self.nutrients = nutrients
        _profile = profile
        self.isDecimal = isDecimal
    }
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(nutrients, id:\.id) { nutrient in
                HStack {
                    Text("\(nutrient.name)")
                    TextField("0.0", text: Binding(
                        get: {
                            return  isDecimal ? String(format: "%.1f", profile.floatValue(key: nutrient.key)) : String(profile.intValue(key: nutrient.key))
                        },
                        set: { newValue in
                            profile.updateRequired(key: nutrient.key, value: newValue)
                        }
                    ))
                    .multilineTextAlignment(.trailing)
                    Text(nutrient.unitText)
                        .frame(minWidth: unitMinWidth)                        
                }
                .foregroundColor(textColor)
                .font(.subheadline)
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let unitMinWidth: CGFloat = 30
    private let textColor = Color("PrimaryTextColor")
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(user: PreviewData.userController)
    }
}
