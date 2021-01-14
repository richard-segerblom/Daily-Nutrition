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
    var profile: NutritionProfile { return user?.nutritionProfile ?? NewNutritionProfile(nutrients: []) }
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
        DispatchQueue.global(qos: .background).async {
            var didUpdate = false
            let all = self.profile.nutrients
            for (key, nutrient) in profile.nutrients {
                guard let original = all[key] else { continue }
                
                if  nutrient.value != original.value {
                    CDNutrient.update(nutrientID: nutrient.id, value: nutrient.value, context: self.persistenceController.container.viewContext)
                    didUpdate = true
                }
            }
            
            DispatchQueue.main.async {
                if didUpdate {
                    self.user = User.loadUser(context: self.persistenceController.container.viewContext)
                }
            }
        }
    }
}
