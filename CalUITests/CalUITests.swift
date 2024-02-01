//
//  CalUITests.swift
//  CalUITests
//
//  Created by Bunny Lin on 2024/1/22.
//

import XCTest

final class CalUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testInputNumber() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let c1 = app.otherElements["c1"]
        XCTAssertEqual(c1.buttons["AC"].label, "AC")
        
        //123456789
        c1.buttons["1"].tap()
        var textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1")
        c1.buttons["2"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "12")
        c1.buttons["3"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123")
        c1.buttons["4"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1,234")
        c1.buttons["5"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "12,345")
        c1.buttons["6"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123,456")
        c1.buttons["7"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1,234,567")
        c1.buttons["8"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "12,345,678")
        c1.buttons["9"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123,456,789")
        c1.buttons["0"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123,456,789")
        XCTAssertEqual(c1.buttons["AC"].label, "C")
        c1.buttons["AC"].tap()
        XCTAssertEqual(c1.buttons["AC"].label, "AC")
        
        //10
        c1.buttons["1"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1")
        c1.buttons["0"].tap()
        textInLabel = c1.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "10")
        XCTAssertEqual(c1.buttons["AC"].label, "C")
        
    }
}
