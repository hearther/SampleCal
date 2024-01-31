//
//  CalView.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/26.
//

import UIKit


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
        
    
    var model:CalModel = CalModel()
    
            
    //MARK: life cycle
    override func awakeFromNib() {
        for btn in btns {
            btn.layer.cornerRadius = min(20, max(btn.frame.height/4, 5));
            //adjust text to btn width
            btn.titleLabel?.numberOfLines = 1
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.titleLabel?.lineBreakMode = .byClipping
            btn.titleLabel?.textAlignment = .center
            btn.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
        }
    }
    override func layoutSubviews() {
        for btn in btns {
            btn.layer.cornerRadius = min(20, max(btn.frame.height/4, 5));
        }
    }
    
    //MARK: public
    public func getCurAcc() -> String {
        return self.model.getCurAccString()
    }
    public func handleTransferFromAnotherCal(_ str: String) {
        self.model.handleTransferFromAnotherCal(str)
    }
    public func clear() {
        self.model.resetAll()
        self.updateUI()
    }

    //MARK: button touch up inside action
    @objc func onTap(_ sender: UIButton){
        if self.opbtns.contains(sender){
                        
            if sender == self.add {
                self.model.doOp("+")
            }
            else if sender == self.sub {
                self.model.doOp("-")
            }
            else if sender == self.mult {
                self.model.doOp("*")
            }
            else if sender == self.div {
                self.model.doOp("/")
            }
            
        }
        else if sender == self.eq {
            self.model.doEq(sender)

        }
        else if sender == self.ac {
            
            if self.model.hadInputSomething() {
                self.model.resetAcc()
            }
            else {
                self.model.resetAll()
            }
            self.updateUI()
        }
        else if sender == self.neg {
            self.model.handleInput("-")
        }
        else if sender == self.dec {
            self.model.handleInput(".")
        }
        else if sender == self.per {
            self.model.doOp("%")
        }
        else {
            var str = self.model.getCurAccString()
            //Portrait input max 9 digits
            if str.count >= 9 {
                return
            }
            // 0 1 2 3 4 5 6 7 8 9
            let d = sender.tag
            self.model.handleInput(String(d))
        }
    }
           
    func updateUI(_ justInputDec:Bool = false){
        
        guard !self.model.isCurAccValid() else {
            self.curValLabel.text = "ERR"
            self.model.resetAll()
            return
        }
                
        var str = self.model.getCurAccString()
        
        if justInputDec{
            str += "."
        }
        self.curValLabel.text = str
        self.formula.text = self.model.getFormulaString()
        
        if self.model.hadInputSomething() {
            self.ac.titleLabel?.text = "C"
        }
        else {
            self.ac.titleLabel?.text = "AC"
        }
    }
    
    
    
}

