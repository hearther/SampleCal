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


enum Operation {
    case add, sub, mult, div, none
}

class CalVC: UIViewController {
    
    @IBOutlet var ansLabel: UILabel!
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
    
    var val:Int64 = 0
    var beforeOpNum:Int64 = 0
    var form = "0"
    var currentOperation: Operation = .none
            
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
                self.currentOperation = .add
            }
            else if sender == self.sub {
                self.currentOperation = .sub
            }
            else if sender == self.mult {
                self.currentOperation = .mult
            }
            else if sender == self.div {
                self.currentOperation = .div
            }
            
            self.val = 0
            self.beforeOpNum = self.val
        }
        else if sender == self.eq {
            let runningValue = self.beforeOpNum
            let currentValue:Int64 = self.val
            switch self.currentOperation {
            case .add:
                self.val = runningValue + currentValue
                self.form = "\(runningValue)+\(currentValue)"
            case .sub:
                self.val = runningValue - currentValue
                self.form = "\(runningValue)-\(currentValue)"
            case .mult:
                self.val = runningValue * currentValue
                self.form = "\(runningValue)*\(currentValue)"
            case .div:
                self.val = runningValue / currentValue
                self.form = "\(runningValue)/\(currentValue)"
            case .none:
                break
            }
            self.formula.text = self.form
        }
        else if sender == self.ac {
            self.val = 0
            self.form = "0"
            self.formula.text = self.form
        }
        else if sender == self.neg {
            self.val *= -1
            self.ansLabel.text = String(self.val)
        }
        else if sender == self.dec {
            
        }
        else if sender == self.per {
            
        }
        else {
            
            let d = sender.tag
            if self.val > 10^9 {
                return
            }
            
            if self.val == 0 {
                val = Int64(d)
            }
            else {
                self.val = val * 10 + Int64(d)
            }
            
            
            if self.val == Int64.max {
                self.ansLabel.text = "INF"
            }
            else if self.val == Int64.min{
                self.ansLabel.text = "-INF"
            }
            else {
                self.ansLabel.text = String(self.val)
            }
            
        }
        
    }
}
