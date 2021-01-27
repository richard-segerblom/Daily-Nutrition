//
//  MealStorageControllerTests.swift
//  NutritionTests
//
//  Created by Richard Segerblom on 2021-01-27.
//

import XCTest
import Combine

@testable import Nutrition

class MealStorageControllerTests: XCTestCase {
    var mealStorage: MealStorageController!
    var persistance: PersistenceController!
    var userController: UserController!
    var pancakes: CDMeal!
    var cancellable: AnyCancellable!

    override func setUpWithError() throws {
        persistance = PersistenceController(inMemory: true)
        userController = UserController(persistenceController: persistance)
        
        let smoothie = CDMeal(context: persistance.container.viewContext, name: "Smoothie", mealCategory: .breakfast)
        pancakes = CDMeal(context: persistance.container.viewContext, name: "Pancakes", mealCategory: .lunch)
        CDMeal(context: persistance.container.viewContext, name: "Hawaiian bowl", mealCategory: .lunch)
    
        CDConsumed(context: persistance.container.viewContext, meal: smoothie, eatable: nil)
        CDConsumed(context: persistance.container.viewContext, meal: pancakes, eatable: nil)
        
        mealStorage = MealStorageController(persistenceController: persistance, userController: userController)
    }

    override func tearDownWithError() throws {
        cancellable = nil
    }

    func test_mealStorageController_init_shouldFetchMeals() {
        XCTAssertEqual(mealStorage.meals.count, 3)
    }
    
    func test_mealStorageController_init_shouldFetchRecent() {
        mealStorage.filter(.recent)
        
        XCTAssertEqual(mealStorage.meals.count, 2)
    }
    
    func test_mealStorageController_filter() {
        // When
        mealStorage.filter(.lunch)
                
        // Then
        XCTAssertEqual(mealStorage.meals.count, 2)
    }
    
    func test_mealStorageController_createMeal() {
        // Given
        let name = "Sushi"
        let category = MealCategory.dinner
  
        let expectation = self.expectation(description: "Expected meal")
        
        // Then
        cancellable = mealStorage.$meals.sink {
            guard let _ = $0.filter({ meal in meal.name == name }).first else { return }
                                        
            expectation.fulfill()
        }
        
        // When
        mealStorage.createMeal(name: name, category: Int(category.rawValue), ingredients: [])
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_mealStorageController_onDeletion_shouldUpdateMeals() {
        let expectation = self.expectation(description: "Expected two meals")
        
        // Then
        cancellable = mealStorage.$meals.sink {
            if $0.count == 2 { expectation.fulfill() }
        }
        
        // When
        persistance.container.viewContext.delete(pancakes)
        persistance.saveChanges()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
