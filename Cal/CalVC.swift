//
//  CalVC.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/22.
//

import UIKit
//ios calc
//Portrait input max 9 digits
//landscape input  max 16 digits
//max number 1e161

extension Formatter {
    static let withCommaSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
extension Double {
    func formatCommaStr(justTapDec just:Bool = false) -> String {
        var ret = ""
        if self == floor(self) && !just{
            //int
            ret = Formatter.withCommaSeparator.string(for: Int(self)) ?? ""
        }
        else if just == true{
            let t = Formatter.withCommaSeparator.string(for: Int(self)) ?? ""
            ret = t+"."
        }
        else {
            ret = String(self)
        }
        return ret
        
    }
}


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


class CalVC: UIViewController {
    
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
    
    var btns:Array<UIButton> = []
    var opbtns:Array<UIButton> = []
        
    var userInput:String = ""
    var acc:Double = 0.0
    
    var numStk: [Double] = [] // Number stack
    var opStk: [String] = [] // Operator stack
    
    private func resetAllDefault (){
        self.userInput = ""
        self.acc = 0.0
        
        self.numStk.removeAll()
        self.opStk.removeAll()
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
        //landscape input  max 16 digits
        if str.count >= 9 {
            return
        }
        if justInputDec{
            str += "."
        }
        self.curValLabel.text = str
    }
    private func doOp(_ newop:String){
        if self.userInput != "" {
            //%
            if (newop == "%"){
                self.acc /= 100
                doEq()
            }
            else if self.numStk.count > 0 && self.opStk.count > 0
            {
                let lastOp = self.opStk.last
                // first * /  then + -
                if !((newop == "*" || newop == "/") && (lastOp == "+" || lastOp == "-")) {
                    let fun = ops[self.opStk.removeLast()]
                    self.acc = fun!(self.numStk.removeLast(), acc)
                    doEq()
                }
            }
        }
        self.opStk.append(newop)
        self.numStk.append(acc)
        self.userInput = ""
        
        updateUI()
    }
    private func doEq() {
        if self.userInput == ""{
            return
        }
        if numStk.count>0 {
            let lastOp = self.opStk.last
            
            if lastOp != nil {
                if ops.keys.contains(lastOp!){
                    let fun = ops[self.opStk.removeLast()]
                    self.acc = fun!(self.numStk.removeLast(), acc)
                    doEq()
                }
            }
        }
        updateUI()
        self.userInput = ""
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.opbtns = [self.div,self.mult, self.add, self.sub]
        self.btns = [
            self.ac, self.neg, self.per,
            
            self.eq,self.dec,
            
            self.zero, self.one, self.two, 
            self.three,self.four, self.five,
            self.six,self.seven, self.eight,
            self.nine
        ]
        self.btns.append(contentsOf: self.opbtns)
        
        for btn in btns{
            btn.layer.cornerRadius = 20;
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func onTap(_ sender: UIButton){
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
            doEq()
//            let runningValue = self.beforeOpNum
//            let currentValue:Double = self.val
//            switch self.currentOperation {
//            case .add:
//                self.val = runningValue + currentValue
//                self.form = "\(runningValue)+\(currentValue)"
//            case .sub:
//                self.val = runningValue - currentValue
//                self.form = "\(runningValue)-\(currentValue)"
//            case .mult:
//                self.val = runningValue * currentValue
//                self.form = "\(runningValue)*\(currentValue)"
//            case .div:
//                self.val = runningValue / currentValue
//                self.form = "\(runningValue)/\(currentValue)"
//            case .none:
//                break
//            }
//            self.formula.text = self.form
        }
        else if sender == self.ac {
            self.resetAllDefault()
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
        
        if self.numStk.count > 0{
            self.ac.titleLabel?.text = "C"
        }
        else {
            self.ac.titleLabel?.text = "AC"
        }
        
    }
    //MARK: private
    
    
}
