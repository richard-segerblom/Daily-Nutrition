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
    @State private var gender = 0
    @State private var age = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    init(user: UserController) {
        self.user = user
        _profile = State(initialValue: NutritionProfileController(profile: user.profile, required: user.profile))
        
        UINavigationBar.setOpaqueBackground()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    Picker("Gender", selection: $gender) {
                        Text("Man").tag(0)
                        Text("Woman").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Picker("Age", selection: $age) {
                        ForEach(0 ..< 120) {
                            Text("\($0)")
                        }
                    }
                }
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
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let unitMinWidth: CGFloat = 30
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(user: PreviewData.userController)
    }
}
