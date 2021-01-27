//
//  ConsumedStorageControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-26.
//

import XCTest
import Combine

@testable import Nutrition

class ConsumedStorageControllerTests: XCTestCase {
    var consumedStorage: ConsumedStorageController!
    var persistance: PersistenceController!
    var userController: UserController!
    var consumedApple: CDConsumed!
    var eatableBanana: CDEatable!
    var cancellable: AnyCancellable!
    
    override func setUpWithError() throws {
        persistance = PersistenceController(inMemory: true)
        userController = UserController(persistenceController: persistance)
        
        let apple = CDFood(context: persistance.container.viewContext, name: "Apple", category: FoodCategory.fruit.rawValue,
                           nutritionProfile: CDNutritionProfile(context: persistance.container.viewContext, food: nil))
        let eatableApple = CDEatable(context: persistance.container.viewContext, amount: 75, food: apple)
        consumedApple = CDConsumed(context: persistance.container.viewContext, meal: nil, eatable: eatableApple)
        
        let quinoa = CDFood(context: persistance.container.viewContext, name: "Quinoa", category: FoodCategory.pantry.rawValue,
                           nutritionProfile: CDNutritionProfile(context: persistance.container.viewContext, food: nil))
        let eatableQuinoa = CDEatable(context: persistance.container.viewContext, amount: 120, food: quinoa)
        CDConsumed(context: persistance.container.viewContext, meal: nil, eatable: eatableQuinoa)
        
        let orange = CDFood(context: persistance.container.viewContext, name: "Orange", category: FoodCategory.fruit.rawValue,
                           nutritionProfile: CDNutritionProfile(context: persistance.container.viewContext, food: nil))
        let eatableOrange = CDEatable(context: persistance.container.viewContext, amount: 150, food: orange)
        CDConsumed(context: persistance.container.viewContext, meal: nil, eatable: eatableOrange, date: Date(timeIntervalSince1970: 0))
        
        let banana = CDFood(context: persistance.container.viewContext, name: "Banana", category: FoodCategory.pantry.rawValue,
                           nutritionProfile: CDNutritionProfile(context: persistance.container.viewContext, food: nil))
        eatableBanana = CDEatable(context: persistance.container.viewContext, amount: 150, food: banana)
        
        consumedStorage = ConsumedStorageController(persistenceController: persistance, userController: userController)
    }
    
    override func tearDownWithError() throws {
        cancellable = nil
    }

    func test_consumedStorageController_init_shouldFetchToday() {
        XCTAssertEqual(consumedStorage.today.count, 2)
    }
    
    func test_consumedStorageController_init_shouldFetchLatest() {
        XCTAssertEqual(consumedStorage.latest.count, 3)
    }
    
    func test_consumedStorageController_deleteConsumed_shouldUpdateToday() {
        let expectation = self.expectation(description: "Expected one item consumed today")
        
        // Then
        cancellable = consumedStorage.$today.sink {
            if $0.count == 1 { expectation.fulfill() }
        }
        
        // When
        persistance.container.viewContext.delete(consumedApple)
        persistance.saveChanges()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_consumedStorageController_addConsumed_shouldUpdateToday() {
        let expectation = self.expectation(description: "Expected three items consumed today")
        
        // Then
        cancellable = consumedStorage.$today.sink {
            if $0.count == 3 { expectation.fulfill() }
        }
        
        // When
        CDConsumed(context: persistance.container.viewContext, meal: nil, eatable: eatableBanana)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_consumedStorageController_deleteConsumed_shouldUpdateLatest() {
        let expectation = self.expectation(description: "Expected two consumed items")
        
        // Then
        cancellable = consumedStorage.$latest.sink {
            if $0.count == 2 { expectation.fulfill() }
        }
        
        // When
        persistance.container.viewContext.delete(consumedApple)
        persistance.saveChanges()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_consumedStorageController_addConsumed_shouldUpdateLates() {
        let expectation = self.expectation(description: "Expected four consumed items")
        
        // Then
        cancellable = consumedStorage.$latest.sink {
            if $0.count == 4 { expectation.fulfill() }
        }
        
        // When       
        CDConsumed(context: persistance.container.viewContext, meal: nil, eatable: eatableBanana)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
