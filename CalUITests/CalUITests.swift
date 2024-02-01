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

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    func testCalInputNumber() throws {
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
        
        let app = XCUIApplication()
        app.launch()
        
        
        let cIdfs = ["c1", "c2"]
        for i in cIdfs {
            let c = app.otherElements[i]
            do {
                try? testInputNumber(c)
                c.buttons["AC"].tap()
                
                try? testFormula1(c)
                c.buttons["AC"].tap()
                try? testFormula2(c)
                c.buttons["AC"].tap()
                try? testFormula3(c)
                c.buttons["AC"].tap()
                try? testFormula4(c)
                c.buttons["AC"].tap()
                
                try? testDecimalPoint(c)
                c.buttons["AC"].tap()
                try? testSignSymbol(c)
                c.buttons["AC"].tap()
                try? testPercentageSymbol(c)
                c.buttons["AC"].tap()
                try? testNan1(c)
            }
            
        }
    }
    
    func testInputNumber(_ c:XCUIElement) throws {
                
        XCTAssertTrue(c.staticTexts["AC"].exists)
        XCTAssertFalse(c.staticTexts["C"].exists)
        
        //123456789
        c.buttons["1"].tap()
        var textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1")
        XCTAssertFalse(c.staticTexts["AC"].exists)
        XCTAssertTrue(c.staticTexts["C"].exists)
        
        c.buttons["2"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "12")
        c.buttons["3"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123")
        c.buttons["4"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1,234")
        c.buttons["5"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "12,345")
        c.buttons["6"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123,456")
        c.buttons["7"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1,234,567")
        c.buttons["8"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "12,345,678")
        c.buttons["9"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123,456,789")
        c.buttons["0"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "123,456,789")
        XCTAssertFalse(c.staticTexts["AC"].exists)
        XCTAssertTrue(c.staticTexts["C"].exists)
        c.buttons["AC"].tap()
        XCTAssertTrue(c.staticTexts["AC"].exists)
        XCTAssertFalse(c.staticTexts["C"].exists)
        
        //10
        c.buttons["1"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "1")
        c.buttons["0"].tap()
        textInLabel = c.staticTexts["curVal"].label
        XCTAssertEqual(textInLabel, "10")
        XCTAssertFalse(c.staticTexts["AC"].exists)
        XCTAssertTrue(c.staticTexts["C"].exists)
    }
    func testDecimalPoint(_ c:XCUIElement) throws {
        
        c.buttons["1"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "1")
        c.buttons["."].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "1")
        c.buttons["0"].tap()
//        XCTAssertEqual(c.getAcc(), "1.0")
        XCTAssertEqual(c.staticTexts["curVal"].label, "1.0")
        
        c.buttons["0"].tap()
        c.buttons["1"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "1.001")
    }
    
    func testSignSymbol(_ c:XCUIElement) throws  {
        c.buttons["1"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "1")
        c.buttons["+/-"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "-1")
        c.buttons["+/-"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "1")
    }
    
    func testPercentageSymbol(_ c:XCUIElement) throws {
        c.buttons["1"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "1")
        c.buttons["%"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "0.01")
        c.buttons["0"].tap()
        c.buttons["9"].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "0.0109")
    }
    
    
    
    //8+2+2=
    func testFormula1(_ c:XCUIElement) throws {
        c.buttons["8"].tap()
        c.buttons["+"].tap()
        c.buttons["2"].tap()
        c.buttons["+"].tap()
        c.buttons["2"].tap()
        c.buttons["="].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "12")
        XCTAssertEqual(c.staticTexts["formula"].label, "8+2+2=12")
    }
    
    //8+2-2=
    func testFormula2(_ c:XCUIElement) throws {
        c.buttons["8"].tap()
        c.buttons["+"].tap()
        c.buttons["2"].tap()
        c.buttons["-"].tap()
        c.buttons["2"].tap()
        c.buttons["="].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "8")
        XCTAssertEqual(c.staticTexts["formula"].label, "8+2-2=8")
    }
    
    //8+2*2=
    func testFormula3(_ c:XCUIElement) throws {
        c.buttons["8"].tap()
        c.buttons["+"].tap()
        c.buttons["2"].tap()
        c.buttons["*"].tap()
        c.buttons["2"].tap()
        c.buttons["="].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "12")
        XCTAssertEqual(c.staticTexts["formula"].label, "8+2*2=12")
    }
    
    //8+2/2=
    func testFormula4(_ c:XCUIElement) throws {
        c.buttons["8"].tap()
        c.buttons["+"].tap()
        c.buttons["2"].tap()
        c.buttons["/"].tap()
        c.buttons["2"].tap()
        c.buttons["="].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "9")
        XCTAssertEqual(c.staticTexts["formula"].label, "8+2/2=9")
    }
    
    
    func testNan1(_ c:XCUIElement) throws {
        c.buttons["1"].tap()
        c.buttons["/"].tap()
        c.buttons["0"].tap()
        c.buttons["="].tap()
        XCTAssertEqual(c.staticTexts["curVal"].label, "ERR")
        XCTAssertEqual(c.staticTexts["formula"].label, "")
    }
    
    
    //MARK: test between c1 and c2
    func testC1ToC2(){
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
        
        let app = XCUIApplication()
        app.launch()
        let c1 = app.otherElements["c1"]
        let c2 = app.otherElements["c2"]
        
        
        try? testFormula2(c1)
        app.buttons["toR"].tap()
        XCTAssertEqual(c2.staticTexts["curVal"].label, "8")
        
        c1.buttons["AC"].tap()
        try? testNan1(c1)
        app.buttons["toR"].tap()
        XCTAssertEqual(c2.staticTexts["curVal"].label, "0")
        
        
    }
    
    func testC2ToC1(){
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
        
        let app = XCUIApplication()
        app.launch()
        let c1 = app.otherElements["c1"]
        let c2 = app.otherElements["c2"]
        
        
        try? testFormula2(c2)
        app.buttons["toL"].tap()
        XCTAssertEqual(c1.staticTexts["curVal"].label, "8")
        
        c1.buttons["AC"].tap()
        try? testNan1(c2)
        app.buttons["toL"].tap()
        XCTAssertEqual(c1.staticTexts["curVal"].label, "0")
    }
    
    
    func testDEL(){
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
        
        let app = XCUIApplication()
        app.launch()
        let c1 = app.otherElements["c1"]
        let c2 = app.otherElements["c2"]
        
        
        try? testFormula1(c2)
        try? testFormula2(c1)
        
        app.buttons["DEL"].tap()
        XCTAssertEqual(c1.staticTexts["curVal"].label, "0")
        XCTAssertEqual(c2.staticTexts["curVal"].label, "0")
    }
    
}
