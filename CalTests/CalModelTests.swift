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
        XCTAssertEqual(model.getAccString(), "1")
        XCTAssertEqual(model.getAcc(), 1)
        model.handleInput("2")
        XCTAssertEqual(model.getAccString(), "12")
        XCTAssertEqual(model.getAcc(), 12)
        model.handleInput("3")
        XCTAssertEqual(model.getAccString(), "123")
        XCTAssertEqual(model.getAcc(), 123)
        model.handleInput("4")
        XCTAssertEqual(model.getAccString(), "1,234")
        XCTAssertEqual(model.getAcc(), 1234)
        model.handleInput("5")
        XCTAssertEqual(model.getAccString(), "12,345")
        XCTAssertEqual(model.getAcc(), 12345)
        model.handleInput("6")
        XCTAssertEqual(model.getAccString(), "123,456")
        XCTAssertEqual(model.getAcc(), 123456)
        model.handleInput("7")
        XCTAssertEqual(model.getAccString(), "1,234,567")
        XCTAssertEqual(model.getAcc(), 1234567)
        model.handleInput("8")
        XCTAssertEqual(model.getAccString(), "12,345,678")
        XCTAssertEqual(model.getAcc(), 12345678)
        model.handleInput("9")
        XCTAssertEqual(model.getAccString(), "123,456,789")
        XCTAssertEqual(model.getAcc(), 123456789)
        model.handleInput("0")
        XCTAssertEqual(model.getAccString(), "1,234,567,890")
        XCTAssertEqual(model.getAcc(), 1234567890)
        XCTAssertFalse(model.isFormulaEnd())
    }
    
    func testDecimalPoint() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        XCTAssertEqual(model.getAcc(), 1)
        model.handleInput(".")
        XCTAssertEqual(model.getAcc(), 1)
        model.handleInput("1")
        XCTAssertEqual(model.getAccString(), "1.1")
        XCTAssertEqual(model.getAcc(), 1.1)
        XCTAssertFalse(model.isFormulaEnd())
        model.handleInput("0")
        model.handleInput("1")
        XCTAssertEqual(model.getAccString(), "1.101")
        XCTAssertEqual(model.getAcc(), 1.101)
        XCTAssertFalse(model.isFormulaEnd())
    }
    
    func testSignSymbol() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        XCTAssertEqual(model.getAcc(), 1)
        model.handleInput("neg")
        XCTAssertEqual(model.getAccString(), "-1")
        XCTAssertEqual(model.getAcc(), -1)
        model.handleInput("neg")
        XCTAssertEqual(model.getAccString(), "1")
        XCTAssertEqual(model.getAcc(), 1)
        XCTAssertFalse(model.isFormulaEnd())
    }
    
    func testPercentageSymbol() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        model.handleInput("%")
        XCTAssertEqual(model.getAccString(), "0.01")
        model.handleInput("9")
        XCTAssertEqual(model.getAccString(), "0.019")
        XCTAssertFalse(model.isFormulaEnd())
    }
    
    
    //*8=
    func testFormula1() throws {
        let model: CalModel = CalModel()
        model.handleInput("*")
        model.handleInput("8")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "0")
        XCTAssertEqual(model.getFormulaString(), "0*8=0")
        XCTAssertTrue(model.isFormulaEnd())
        
    }
    
    //8+2+2=
    func testFormula2() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "12")
        XCTAssertEqual(model.getFormulaString(), "8+2+2=12")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8+2-2=
    func testFormula3() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "8")
        XCTAssertEqual(model.getFormulaString(), "8+2-2=8")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8+2*2=
    func testFormula4() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "12")
        XCTAssertEqual(model.getFormulaString(), "8+2*2=12")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8+2/2=
    func testFormula5() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "9")
        XCTAssertEqual(model.getFormulaString(), "8+2/2=9")
        XCTAssertTrue(model.isFormulaEnd())
    }
        
    //8-2+2=
    func testFormula6() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "8")
        XCTAssertEqual(model.getFormulaString(), "8-2+2=8")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8-2-2=
    func testFormula7() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "4")
        XCTAssertEqual(model.getFormulaString(), "8-2-2=4")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8-2*2=
    func testFormula8() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "4")
        XCTAssertEqual(model.getFormulaString(), "8-2*2=4")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8-2/2=
    func testFormula9() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "7")
        XCTAssertEqual(model.getFormulaString(), "8-2/2=7")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8*2+2=
    func testFormula10() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "18")
        XCTAssertEqual(model.getFormulaString(), "8*2+2=18")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8*2-2=
    func testFormula11() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "14")
        XCTAssertEqual(model.getFormulaString(), "8*2-2=14")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8*2*2=
    func testFormula12() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "32")
        XCTAssertEqual(model.getFormulaString(), "8*2*2=32")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8*2/2=
    func testFormula13() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "8")
        XCTAssertEqual(model.getFormulaString(), "8*2/2=8")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8/2+2=
    func testFormula14() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("+")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "6")
        XCTAssertEqual(model.getFormulaString(), "8/2+2=6")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //8/2-2=
    func testFormula15() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("-")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "2")
        XCTAssertEqual(model.getFormulaString(), "8/2-2=2")
        XCTAssertTrue(model.isFormulaEnd())
    }
    //8/2*2=
    func testFormula16() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("*")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "8")
        XCTAssertEqual(model.getFormulaString(), "8/2*2=8")
        XCTAssertTrue(model.isFormulaEnd())
    }
    //8/2/2=
    func testFormula17() throws {
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "2")
        XCTAssertEqual(model.getFormulaString(), "8/2/2=2")
        XCTAssertTrue(model.isFormulaEnd())
    }
    
    //0.5*0.5=
    func testFormula18() throws {
        let model: CalModel = CalModel()
        model.handleInput("0")
        model.handleInput(".")
        model.handleInput("5")
        XCTAssertEqual(model.getAccString(), "0.5")
        model.handleInput("*")
        model.handleInput("3")
        XCTAssertEqual(model.getAccString(), "3")
        model.handleInput("=")
        XCTAssertEqual(model.getAccString(), "1.5")
        XCTAssertTrue(model.isFormulaEnd())
    }
  
    func testNan1() throws {
        let model: CalModel = CalModel()
        model.handleInput("1")
        model.handleInput("/")
        model.handleInput("0")
        model.handleInput("=")
        XCTAssertFalse(model.isCurAccValid())
        XCTAssertFalse(model.isFormulaEnd())
    }
    
    func testNan2() throws {
        let model: CalModel = CalModel()
        XCTAssertFalse(model.hadInputSomething())
        model.handleInput("NaN")
        XCTAssertFalse(model.hadInputSomething())
        XCTAssertEqual(model.getAccString(), "0")
    }
    
    func testError() throws {
        let model: CalModel = CalModel()
        XCTAssertFalse(model.hadInputSomething())
        model.handleInput("a")
        XCTAssertFalse(model.hadInputSomething())
        XCTAssertEqual(model.getAccString(), "0")
        model.handleInput("O")
        XCTAssertFalse(model.hadInputSomething())
        XCTAssertEqual(model.getAccString(), "0")
        model.handleInput("Something")
        XCTAssertFalse(model.hadInputSomething())
        XCTAssertEqual(model.getAccString(), "0")
        
    }
    
    
    func testHadInput() throws {
        let model: CalModel = CalModel()
        XCTAssertFalse(model.hadInputSomething())
        model.handleInput("1")
        XCTAssertTrue(model.hadInputSomething())
        model.handleInput("/")
        XCTAssertTrue(model.hadInputSomething())
        model.handleInput("1")
        XCTAssertTrue(model.hadInputSomething())
        model.handleInput("=")
        XCTAssertTrue(model.hadInputSomething())
    }
    
    func testDec() throws {
        let model: CalModel = CalModel()
        XCTAssertFalse(model.hadInputSomething())
        model.handleInput("1")
        model.handleInput(".")
        XCTAssertEqual(model.getAccString(), "1")
        XCTAssertTrue(model.hadInputSomething())
        model.handleInput(".")
        XCTAssertEqual(model.getAccString(), "1")
        model.handleInput("5")
        XCTAssertEqual(model.getAccString(), "1.5")
                
    }
    
    func testTwoEq() throws {
        let model: CalModel = CalModel()
        XCTAssertFalse(model.hadInputSomething())
        model.handleInput("=")
        XCTAssertFalse(model.hadInputSomething())
        model.handleInput("=")
        XCTAssertFalse(model.hadInputSomething())
    }
    
    func testTransfer() throws{
        let model: CalModel = CalModel()
        let model1: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("/")
        model.handleInput("2")
        model.handleInput("=")
        
        model1.handleTransferAccFromAnotherCal(model.getAcc() )
        
        XCTAssertEqual(model1.getAccString(), "2")
        XCTAssertTrue(model1.hadInputSomething())
        XCTAssertFalse(model1.isFormulaEnd())
        XCTAssertEqual(model1.getFormulaString(), "")
    }
    
    func testReset() throws{
        let model: CalModel = CalModel()
        model.handleInput("8")
        model.handleInput("/")
        model.handleInput("2")
        model.resetAcc()
        model.handleInput("4")
        model.handleInput("=")
                
        XCTAssertEqual(model.getAccString(), "2")
        XCTAssertEqual(model.getFormulaString(), "8/4=2")
        XCTAssertTrue(model.hadInputSomething())
        XCTAssertTrue(model.isFormulaEnd())
        model.resetAll()
        XCTAssertEqual(model.getAccString(), "0")
        XCTAssertEqual(model.getFormulaString(), "")
        XCTAssertFalse(model.hadInputSomething())
        XCTAssertFalse(model.isFormulaEnd())
    }
    
    
    //MARK: double extension
    func testDouble(){
        let d = Double.infinity
        XCTAssertNil(d.formatCommaStr())
    }
    

}
