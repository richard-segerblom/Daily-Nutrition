//
//  ReferenceDailyIntakeTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-22.
//

import Foundation

@testable import Nutrition

class MockUserDefaults : UserDefaults {
    var gender: Int?
    var age: Int?
    var profileID: Any?
        
    convenience init() {
        self.init(suiteName: "Mock User Defaults")!
    }
            
    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
        
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == UserDefaults.Keys.gender.rawValue {
            gender = value
        } else if defaultName == UserDefaults.Keys.age.rawValue {
            age = value
        }
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if defaultName == UserDefaults.Keys.profileID.rawValue {
            profileID = value
        }
    }
    
    override func integer(forKey defaultName: String) -> Int {
        if defaultName == UserDefaults.Keys.gender.rawValue {
            return gender ?? -1
        } else if defaultName == UserDefaults.Keys.age.rawValue {
            return age ?? -1
        }
        return -1
    }
    
    override func string(forKey defaultName: String) -> String? {
        if defaultName == UserDefaults.Keys.profileID.rawValue {
            return profileID as? String
        }
        return nil
    }
}
