//
//  DeletionUITests.swift
//  NutritionUITests
//
//  Created by Richard Segerblom on 2021-02-01.
//

import XCTest

class DeletionUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["--uitesting", "-user"]
        app.launch()
        
        continueAfterFailure = false
    }

    func test_deleteMeal() {
        _ = app.buttons["MEALS"].waitForExistence(timeout: 5)
        app.buttons["MEALS"].tap()

        _ = app.navigationBars["All Meals"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).press(forDuration: 1.5)
        app.collectionViews.buttons["Delete"].tap()
        
        XCTAssertEqual(app.collectionViews.cells.count, 0)
    }
    
    func test_deleteConsumed_fromDetailPage() throws {
        try XCTSkipIf(UIDevice.current.userInterfaceIdiom == .pad)
        
        _ = app.buttons["MEALS"].waitForExistence(timeout: 5)
        app.buttons["MEALS"].tap()

        _ = app.navigationBars["All Meals"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).press(forDuration: 1.5)
        app.collectionViews.buttons["Eat"].tap()
        
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["clock"].tap()
        
        _ = app.navigationBars["Consumed Today"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        
        _ = app.scrollViews.firstMatch.waitForExistence(timeout: 5)
        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.firstMatch.swipeUp()
        app.scrollViews.otherElements.buttons["DELETE"].tap()
        
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["clock"].tap()
        
        XCTAssertEqual(app.tables.cells.count, 0)
    }
    
    func test_deleteConsumed_fromContextMenu() throws {
        try XCTSkipIf(UIDevice.current.userInterfaceIdiom == .pad)
        
        _ = app.buttons["MEALS"].waitForExistence(timeout: 5)
        app.buttons["MEALS"].tap()

        _ = app.navigationBars["All Meals"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).press(forDuration: 1.5)
        app.collectionViews.buttons["Eat"].tap()
        
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["clock"].tap()
        
        _ = app.navigationBars["Consumed Today"].waitForExistence(timeout: 5)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).press(forDuration: 1.5)
        app.collectionViews.buttons["Delete"].tap()
                    
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["clock"].tap()
        
        XCTAssertEqual(app.tables.cells.count, 0)
    }

}
