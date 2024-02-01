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
    func getAcc() -> Double {
        return self.acc
    }
    func getAccString() -> String {
        let str = self.acc.formatCommaStr()
        return str == nil ? "" : str!
    }
    func handleTransferAccFromAnotherCal(_ acc: Double) {
        self.acc = acc
        self.userInput = String(self.acc)
        self.view?.updateUI()
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
    
    func isFormulaEnd() -> Bool{
        return self.fStk.contains("=")
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
        
        
        if input == "+" || input == "-" || input == "*" || input == "/" || input == "%" {
            self.doOp(input)
            return
        }
        else if input == "="{
            self.doEq(true)
            return
        }
        
        //handle .
        if input == "." && self.userInput.firstIndex(of: ".") != nil {
            return
        }
        
        if input == "neg"{
            if self.userInput.hasPrefix("-"){
                self.userInput = String(self.userInput[self.userInput.index(after: self.userInput.startIndex)...])
            }
            else {
                self.userInput = "-" + self.userInput
            }
        }
        else {
            self.userInput += input
        }
        acc = Double(self.userInput) ?? 0.0
        if self.acc.isInfinite || self.acc.isNaN {
            self.resetAll()
            self.view?.updateUI()
        }
        else {
            self.view?.updateUI(input==".")
        }
    }
    
    private func doOp(_ newop:String){
        
        //%
        if (newop == "%"){
            self.acc /= 100
            self.userInput = String(self.acc)
            self.view?.updateUI()
            return
        }
        
        
        if self.acc != 0{
            //continue with last calculation
            self.fStk.append(self.getAccString())
        }
        else if self.userInput == ""{
            //just start with ops
            self.fStk.append("0")
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
        
        self.fStk.append(newop)
        self.opStk.append(newop)
        self.numStk.append(acc)
        self.userInput = ""
        self.view?.updateUI()
    }
    
    private func doEq(_ formulaEnd:Bool = false) {
        
        if self.userInput == ""{
            return
        }
        
        if formulaEnd && self.userInput != "" {
            self.fStk.append(self.getAccString())
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
        
        if formulaEnd && self.isCurAccValid() {
            //complete full formula
            self.fStk.append("=")
            self.fStk.append(self.getAccString())
        }
        
        self.view?.updateUI()
    }
    
    //MARK: private
    
}
