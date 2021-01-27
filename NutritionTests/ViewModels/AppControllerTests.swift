//
//  AppControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-26.
//

import XCTest

@testable import Nutrition

class AppControllerTests: XCTestCase {
    var userDefaults: UserDefaults!
    
    override func setUpWithError() throws {
        userDefaults = MockUserDefaults()
    }
    
    func test_appController_init_shouldNotPopulateStorage() throws {
        // Given
        userDefaults.set(true, forKey: UserDefaults.StorageKeys.isStoragePopulated.rawValue)
        let expectation = self.expectation(description: "storagePopulated")
        
        // When
        let appController = AppController(inMemoryStorage: true, userDefaults: userDefaults) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        let persistence = try XCTUnwrap(appController?.persitence)
        XCTAssertTrue(CDFood.all(context: persistence.container.viewContext).isEmpty)
    }

    func test_appController_init_shouldPopulateStorage() throws {
        // Given
        userDefaults.set(false, forKey: UserDefaults.StorageKeys.isStoragePopulated.rawValue)
        let expectation = self.expectation(description: "storagePopulated")
        
        // When
        let appController = AppController(inMemoryStorage: true, userDefaults: userDefaults) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        let persistence = try XCTUnwrap(appController?.persitence)
        XCTAssertFalse(CDFood.all(context: persistence.container.viewContext).isEmpty)
    }
}
