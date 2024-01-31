//
//  CalTests.swift
//  CalTests
//
//  Created by Bunny Lin on 2024/1/22.
//

import XCTest
@testable import Cal

final class CalTests: XCTestCase {
    
    

    override func setUp() {
        super.setUp()
    }
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInputNumber() throws {
        let model: CalModel = CalModel()
        
        model.handleInput("1")
        XCTAssertEqual(model.getCurAccString(), "1")
        model.handleInput("2")
        XCTAssertEqual(model.getCurAccString(), "12")
        model.handleInput("3")
        XCTAssertEqual(model.getCurAccString(), "123")
        model.handleInput("4")
        XCTAssertEqual(model.getCurAccString(), "1,234")
        model.handleInput("5")
        XCTAssertEqual(model.getCurAccString(), "12,345")
        model.handleInput("6")
        XCTAssertEqual(model.getCurAccString(), "123,456")
        model.handleInput("7")
        XCTAssertEqual(model.getCurAccString(), "1,234,567")
        model.handleInput("8")
        XCTAssertEqual(model.getCurAccString(), "12,345,678")
        model.handleInput("9")
        XCTAssertEqual(model.getCurAccString(), "123,456,789")
        model.handleInput("0")
        XCTAssertEqual(model.getCurAccString(), "1,234,567,890")
    }
    
    func testDecimalPoint() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        model.handleInput(".")
        model.handleInput("1")
        XCTAssertEqual(model.getCurAccString(), "1.1")
        model.handleInput("0")
        model.handleInput("1")
        XCTAssertEqual(model.getCurAccString(), "1.101")
    }
    
    func testSignSymbol() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        model.handleInput("neg")
        XCTAssertEqual(model.getCurAccString(), "-1")
        model.handleInput("neg")
        XCTAssertEqual(model.getCurAccString(), "1")
    }
    
    func testPercentageSymbol() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        model.handleInput("%")
        XCTAssertEqual(model.getCurAccString(), "0.01")
        model.handleInput("9")
        XCTAssertEqual(model.getCurAccString(), "0.019")
    }
    
    
    //*8=
    func testFormula1() throws {
        let model: CalModel = CalModel()
        model.handleInput("*")
        model.handleInput("8")
        model.handleInput("=")
        XCTAssertEqual(model.getCurAccString(), "0")
        XCTAssertEqual(model.getFormulaString(), "0*8=0")
        
    }
    
    //8+2-1=
    func testFormula2() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("-")
        model.handleInput("1")
        model.handleInput("=")
        XCTAssertEqual(model.getCurAccString(), "9")
        XCTAssertEqual(model.getFormulaString(), "8+2-1=9")
    }
    
    //8+2*2=
    func testFormula3() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getCurAccString(), "12")
        XCTAssertEqual(model.getFormulaString(), "8+2*2=12")
    }

    func testNan() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        model.handleInput("/")
        model.handleInput("0")
        model.handleInput("=")
        XCTAssertFalse(model.isCurAccValid())
    }
    

}
