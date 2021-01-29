//
//  FoodStorageTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-26.
//

import XCTest
import Combine

@testable import Nutrition

class FoodStorageTests: XCTestCase {
    var foodStorage: FoodStorageController!
    var persistance: PersistenceController!
    var userController: UserController!
    
    override func setUpWithError() throws {
        persistance = PersistenceController(inMemory: true)
        try Populate.storageWithFood(persistance.container.viewContext, file: FoodFileNames.fruits.rawValue)
        try Populate.storageWithFood(persistance.container.viewContext, file: FoodFileNames.vegetables.rawValue)
        
        userController = UserController(persistenceController: persistance)
        foodStorage = FoodStorageController(persistenceController: persistance, userController: userController)
    }


    func test_foodStorageController_init_shouldFetchFood() {
        XCTAssertFalse(foodStorage.foods.isEmpty)
    }
    
    func test_foodStorageController_filter() {
        // When
        foodStorage.filter(.vegetables)
                
        // Then
        let vegetables = foodStorage.foods.filter { $0.category == .vegetables }
        XCTAssertEqual(vegetables.count, foodStorage.foods.count, "Should only contain vegetables")
    }
}
