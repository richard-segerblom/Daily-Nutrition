//
//  Session.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//

import Combine
import CoreData

final class UserController: ObservableObject {
    @Published var user: User?
    let persistenceController: PersistenceController
    
    var isUserSetUp: Bool { user != nil }
    var profile: NutritionProfile { user?.nutritionProfile ?? NewNutritionProfile(nutrients: []) }
    var age: Int { user?.age ?? 0 }
    var gender: Gender { user?.gender ?? .unknown }
    
    init(persistenceController: PersistenceController, user: User? = nil) {
        self.persistenceController = persistenceController
        self.user = user
        
        if user == nil {
            self.user = User.loadUser(context: persistenceController.container.viewContext)
        }
    }
    
    func setupNewUser(gender: Gender, age: Int) {
        user = User.makeNewUser(age: age, gender: gender, persistenceController: persistenceController)
    }
    
    func updateNutrients(profile: NutritionProfile) {
        if hasProfileChanged(profile: profile) {
            // TODO Implement..
        }
    }
    
    private func hasProfileChanged(profile: NutritionProfile) -> Bool {
        let original = self.profile.nutrients
        let new = profile.nutrients
        for (key, nutrient) in new {
            if nutrient.value == original[key]?.value {
                return true
            }
        }
        return false
    }
}
