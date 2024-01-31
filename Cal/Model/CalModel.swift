//
//  CalModel.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/30.
//

import UIKit

typealias BinOp = (Double, Double) -> Double
//MARK: math functions + - * /
private func _addFun(a: Double, b: Double) -> Double {
    let result = a + b
    return result
}
private func _subFun(a: Double, b: Double) -> Double {
    let result = a - b
    return result
}
private func _mulFun(a: Double, b: Double) -> Double {
    let result = a * b
    return result
}
private func _divFun(a: Double, b: Double) -> Double {
    let result = a / b
    return result
}

let ops: [String: BinOp] = [ "+" : _addFun, "-" : _subFun, "*" : _mulFun, "/" : _divFun]

class CalModel {
    
    weak var view: CalView?
    
    private var userInput:String = ""
    
    private var numStk: [Double] = [] // Number stack
    private var opStk: [String] = [] // Operator stack
    private var fStk: [String] = [] // formula stack
    private var acc:Double = 0.0
    
    //MARK: public
    func isCurAccValid() -> Bool {
        return !self.acc.isInfinite && !self.acc.isNaN
    }
    func getCurAccString() -> String {
        return self.acc.formatCommaStr()
    }
    func handleTransferFromAnotherCal(_ str: String) {
        //parse string and input
        for c in Array(str){
            self.handleInput(String(c))
        }
    }
        
    func hadInputSomething()->Bool {
        if self.numStk.count > 0 || self.acc != 0 {
            return true
        }
        return false
    }
        
    func getFormulaString() -> String{
        return self.fStk.reduce("", {(str, n) ->String in return str+n})
    }
    
    func resetAcc (){
        self.userInput = ""
        self.acc = 0.0
        
    }
    
    func resetAll (){
        self.resetAcc()
        
        self.numStk.removeAll()
        self.opStk.removeAll()
        self.fStk.removeAll()
    }
    func handleInput(_ input:String){
        
        //handle .
        if input == "." && self.userInput.firstIndex(of: ".") != nil {
            return
        }
        
        if input == "-"{
            if self.userInput.hasPrefix("-"){
                self.userInput = String(self.userInput[self.userInput.index(after: self.userInput.startIndex)...])
            }
            else {
                self.userInput = input + self.userInput
            }
        }
        else {
            self.userInput += input
        }
        acc = Double((self.userInput as NSString).doubleValue)
        if self.acc.isInfinite || self.acc.isNaN {
            self.resetAll()
        }
        self.view?.updateUI(input==".")
    }
    
    func doOp(_ newop:String){
        
        if self.acc != 0{
            //continue with last calculation
            self.fStk.append(self.acc.formatCommaStr())
        }
        else if self.userInput == ""{
            //just start with ops
            self.fStk.append("0")
        }
        else {
            //%
            if (newop == "%"){
                self.acc /= 100
                self.view?.updateUI()
                return
            }
                                    
            if self.numStk.count > 0 && self.opStk.count > 0
            {
                let lastOp = self.opStk.last!
                                
                // first * /  then + -
                if !((newop == "*" || newop == "/") && (lastOp == "+" || lastOp == "-")) {
                    self.opStk.removeLast()
                    let fun = ops[lastOp]
                    self.acc = fun!(self.numStk.removeLast(), acc)
                    doEq()
                }
            }
        }
        
        self.fStk.append(newop)
        self.opStk.append(newop)
        self.numStk.append(acc)
        self.userInput = ""
        self.view?.updateUI()
    }
    
    func doEq(_ sender:UIButton? = nil) {
        
        if self.userInput == ""{
            return
        }
        
        if sender != nil && self.userInput != "" {
            self.fStk.append(self.acc.formatCommaStr())
        }
                
        //calculate the result
        while numStk.count>0 {
            let lastOp = self.opStk.last
            
            if lastOp != nil {
                if ops.keys.contains(lastOp!){
                    self.opStk.removeLast()
                    let fun = ops[lastOp!]
                    self.acc = fun!(self.numStk.removeLast(), acc)
                }
                
            }
        }
        
        if sender != nil {
            //complete full formula
            self.fStk.append("="+self.acc.formatCommaStr())
        }
        
        self.view?.updateUI()
        self.userInput = ""
        self.fStk.removeAll()
    }
    
    //MARK: private
    
}
