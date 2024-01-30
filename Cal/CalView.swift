//
//  CalView.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/26.
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


class CalView: UIView {
    
    
    
    @IBOutlet var curValLabel: UILabel!
    @IBOutlet var formula: UILabel!
    
    @IBOutlet var ac: UIButton!
    @IBOutlet var neg: UIButton!
    @IBOutlet var per: UIButton!
    
    @IBOutlet var div: UIButton!
    @IBOutlet var mult: UIButton!
    @IBOutlet var add: UIButton!
    @IBOutlet var sub: UIButton!
    @IBOutlet var eq: UIButton!
    @IBOutlet var dec: UIButton!
    
    @IBOutlet var zero: UIButton!
    @IBOutlet var one: UIButton!
    @IBOutlet var two: UIButton!
    @IBOutlet var three: UIButton!
    @IBOutlet var four: UIButton!
    @IBOutlet var five: UIButton!
    @IBOutlet var six: UIButton!
    @IBOutlet var seven: UIButton!
    @IBOutlet var eight: UIButton!
    @IBOutlet var nine: UIButton!
    
    @IBOutlet var btns : [UIButton] = []
    @IBOutlet var opbtns : [UIButton]  = []
        
    var userInput:String = ""
    var acc:Double = 0.0
    
    var numStk: [Double] = [] // Number stack
    var opStk: [String] = [] // Operator stack
    var fStk: [String] = [] // formula stack
    
    //MARK: life cycle
                
    override func awakeFromNib() {
        for btn in btns {
            btn.layer.cornerRadius = 20;
            //adjust text to btn width
            btn.titleLabel?.numberOfLines = 1
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.titleLabel?.lineBreakMode = .byClipping
            btn.titleLabel?.textAlignment = .center
            btn.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
        }
    }
    //MARK: public
    public func getCurAcc() -> String {
        return self.acc.formatCommaStr()
    }
    public func handleTransferFromAnotherCal(_ str: String) {
        //parse string and input
        for c in Array(str){
            self.handleInput(String(c))
        }
    }
    public func clear() {
        self.resetAllDefault()
        updateUI()
    }

    //MARK: button touch up inside action
    @objc func onTap(_ sender: UIButton){
        if self.opbtns.contains(sender){
            
            
            if sender == self.add {
                doOp("+")
            }
            else if sender == self.sub {
                doOp("-")
            }
            else if sender == self.mult {
                doOp("*")
            }
            else if sender == self.div {
                doOp("/")
            }
            
        }
        else if sender == self.eq {
            doEq(sender)

        }
        else if sender == self.ac {
            if self.numStk.count > 0 || self.acc != 0 {
                self.userInput = ""
                self.acc = 0
            }
            else {
                self.resetAllDefault()
            }
            updateUI()
        }
        else if sender == self.neg {
            handleInput("-")
        }
        else if sender == self.dec {
            if self.userInput.firstIndex(of: ".") != nil {
                return
            }
            handleInput(".")
        }
        else if sender == self.per {
            doOp("%")
        }
        else {
            // 0 1 2 3 4 5 6 7 8 9
            let d = sender.tag
            handleInput(String(d))
        }
        
        
        
    }
    //MARK: private
    private func resetAllDefault (){
        self.userInput = ""
        self.acc = 0.0
        
        self.numStk.removeAll()
        self.opStk.removeAll()
        self.fStk.removeAll()
    }

    private func handleInput(_ input:String){
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
        updateUI(input==".")
    }
    private func updateUI(_ justInputDec:Bool = false){
        
        guard !self.acc.isInfinite && !self.acc.isNaN else {
            self.curValLabel.text = "ERR"
            self.resetAllDefault()
            return
        }
                
        var str = self.acc.formatCommaStr()
        //Portrait input max 9 digits
        if str.count >= 9 {
            return
        }
        if justInputDec{
            str += "."
        }
        self.curValLabel.text = str
                
        let t:String = self.fStk.reduce("", {(str, n) ->String in return str+n})
        self.formula.text = t
        
        if self.numStk.count > 0 || self.acc != 0 {
            self.ac.titleLabel?.text = "C"
        }
        else {
            self.ac.titleLabel?.text = "AC"
        }
    }
    private func doOp(_ newop:String){
        
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
                updateUI()
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
        updateUI()
    }
    
    private func doEq(_ sender:UIButton? = nil) {
        
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
        
        updateUI()
        self.userInput = ""
        self.fStk.removeAll()
    }
    
    
}

