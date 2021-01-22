//
//  Nutrient+CoreDataClass.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-27.
//
//

import Foundation
import CoreData

struct User {
    var age: Int
    var gender: Gender
    var nutritionProfile: NutritionProfile
}

extension User {
    static func saveGender(gender: Gender, userDefault: UserDefaults = UserDefaults.standard) {
        userDefault.set(gender.rawValue, forKey: UserDefaults.Keys.gender.rawValue)
    }
    
    static func saveAge(age: Int, userDefault: UserDefaults = UserDefaults.standard) {
        userDefault.set(age, forKey: UserDefaults.Keys.age.rawValue)
    }
    
    static func saveNutritionProfileID(id: UUID, userDefault: UserDefaults = UserDefaults.standard) {
        userDefault.set(id.uuidString, forKey: UserDefaults.Keys.profileID.rawValue)
    }
        
    static func loadUser(context:  NSManagedObjectContext, userDefault: UserDefaults = UserDefaults.standard) -> User? {
        let age = userDefault.integer(forKey: UserDefaults.Keys.age.rawValue)
        if age == 0 { return nil }
        
        guard let gender = Gender(rawValue: userDefault.integer(forKey: UserDefaults.Keys.gender.rawValue)) else { return nil }
                
        guard let idString = userDefault.string(forKey: UserDefaults.Keys.profileID.rawValue),
              let id = UUID(uuidString: idString),
              let profile = CDNutritionProfile.withID(id, context: context) else {
            return nil
        }
        
        return User(age: age, gender: gender, nutritionProfile: profile)
    }
    
    static func makeNewUser(age: Int, gender: Gender, persistenceController: PersistenceController,
                            userDefault: UserDefaults = UserDefaults.standard) -> User {
        let required = ReferenceDailyIntake.nutritionProfile(gender: gender, age: age)
        let profile = CDNutritionProfile.add(profile: required, context: persistenceController.container.viewContext)
        
        User.saveAge(age: age, userDefault: userDefault)
        User.saveGender(gender: gender, userDefault: userDefault)
        User.saveNutritionProfileID(id: profile.id, userDefault: userDefault)
                                
        return User(age: age, gender: gender, nutritionProfile: profile)
    }
}

extension UserDefaults {
    enum Keys: String {
        case gender
        case age
        case profileID
    }
}

enum Gender: Int {
    case man
    case woman
    case unknown
}
