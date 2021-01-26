//
//  UserTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-22.
//

import XCTest

@testable import Nutrition

class UserTests: XCTestCase {
    var persistence: PersistenceController!
    var userDefaults: MockUserDefaults!

    override func setUpWithError() throws {
        persistence = PersistenceController(inMemory: true)
        userDefaults = MockUserDefaults()
    }    

    func test_makeNewUser_shouldSaveUser() {
        // Given
        let gender = Gender.woman
        let age = 37
        
        // When
        let _ = User.makeNewUser(age: age, gender: gender, persistenceController: persistence, userDefault: userDefaults)
        
        // Then
        XCTAssertNotNil(userDefaults.gender)
        XCTAssertNotNil(userDefaults.age)
        XCTAssertNotNil(userDefaults.profileID)
    }
    
    func test_makeNewUser_shouldSetupUser() {
        // Given
        let gender = Gender.woman
        let age = 37
        
        // When
        let user = User.makeNewUser(age: age, gender: gender, persistenceController: persistence, userDefault: userDefaults)
        
        // Then
        XCTAssertEqual(user.gender, gender)
        XCTAssertEqual(user.age, age)
        XCTAssertNotNil(user.nutritionProfile)
    }
    
    func test_loadUser_shouldReturnUser() {
        // Given
        let _ = User.makeNewUser(age: 44, gender: .woman, persistenceController: persistence, userDefault: userDefaults)
                        
        // When
        XCTAssertNotNil(User.loadUser(context: persistence.container.viewContext, userDefault: userDefaults))
    }

    func test_loadUser_shouldReturnNil() throws {
        // When
        XCTAssertNil(User.loadUser(context: persistence.container.viewContext, userDefault: userDefaults))
    }
}
