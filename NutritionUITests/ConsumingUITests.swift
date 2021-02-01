//
//  ConsumingUITests.swift
//  NutritionUITests
//
//  Created by Richard Segerblom on 2021-01-30.
//

import XCTest

class ConsumingUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["--uitesting", "-user"]
        app.launch()
        
        continueAfterFailure = false
    }

    func test_eatFood() {
        _ = app.buttons["FOOD"].waitForExistence(timeout: 5)
        app.buttons["FOOD"].tap()

        _ = app.navigationBars["Eat Something?"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()

        _ = app.sliders["amountPicker"].waitForExistence(timeout: 5)
        app.sliders["amountPicker"].adjust(toNormalizedSliderPosition: 0.3)
        app.buttons["EAT"].firstMatch.tap()

        if UIDevice.current.userInterfaceIdiom == .phone {
            app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["clock"].tap()
            XCTAssertEqual(app.tables.cells.count, 1)
        } else {
            XCTAssertEqual(app.collectionViews["consumedTodayPager"].cells.count, 1)
        }
    }
    
    func test_eatMeal() {
        _ = app.buttons["MEALS"].waitForExistence(timeout: 5)
        app.buttons["MEALS"].tap()

        _ = app.navigationBars["All Meals"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()

        _ = app.scrollViews.firstMatch.waitForExistence(timeout: 5)
        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.otherElements.buttons["EAT"].tap()

        if UIDevice.current.userInterfaceIdiom == .phone {
            app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["clock"].tap()
            XCTAssertEqual(app.tables.cells.count, 1)
        } else {
            XCTAssertEqual(app.collectionViews["consumedTodayPager"].cells.count, 1)
        }
    }
}
