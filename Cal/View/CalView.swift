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
        self.model.view = self
        for btn in btns {
            btn.layer.cornerRadius = min(20, max(btn.frame.height/4, 5));
            //adjust text to btn width
            btn.titleLabel?.numberOfLines = 1
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.titleLabel?.lineBreakMode = .byClipping
            btn.titleLabel?.textAlignment = .center
            btn.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
        }
        curValLabel.accessibilityIdentifier = "curVal"
        formula.accessibilityIdentifier = "formula"
        
    }
    override func layoutSubviews() {
        for btn in btns {
            btn.layer.cornerRadius = min(20, max(btn.frame.height/4, 5));
        }
    }
    
    //MARK: public
    //
    public func getAcc() -> (Double){
        return self.model.getAcc()
    }
    public func getAccString() -> (String, Bool) {
                
        let str = self.model.getAccString()
        //Portrait input max 9 digits + 2 comma 12345678.12 ? -1234567890
        if str.count >= 11 {
            return (String(str.prefix(11)), true)
        }
        else {
            return (str, false)
        }
    }
    public func handleTransferAccFromAnotherCal(_ acc: Double) {
        self.model.handleTransferAccFromAnotherCal(acc)
    }
    public func clear() {
        self.model.resetAll()
        self.updateUI()
    }

    //MARK: button touch up inside action
    @objc func onTap(_ sender: UIButton){
        
        if self.model.isFormulaEnd()
        {
            let s = self.getAcc()
            self.model.resetAll()
            self.model.handleTransferAccFromAnotherCal(s)
        }
        
               
        if self.opbtns.contains(sender){
                        
            if sender == self.add {
                self.model.handleInput("+")
            }
            else if sender == self.sub {
                self.model.handleInput("-")
            }
            else if sender == self.mult {
                self.model.handleInput("*")
            }
            else if sender == self.div {
                self.model.handleInput("/")
            }
            
        }
        else if sender == self.eq {
            self.model.handleInput("=")

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
            self.model.handleInput("neg")
        }
        else if sender == self.dec {
            self.model.handleInput(".")
        }
        else if sender == self.per {
            self.model.handleInput("%")
        }
        else {
            let str = self.model.getAccString()
            //Portrait input max 9 digits + 2 comma
            if str.count >= 11 {
                return
            }
            // 0 1 2 3 4 5 6 7 8 9
            let d = sender.tag
            self.model.handleInput(String(d))
        }
    }
           
    func updateUI(){
        
        guard self.model.isCurAccValid() else {
            self.curValLabel.text = "ERR"
            self.formula.text=""
            self.model.resetAll()
            return
        }
                
        var (str, _) = self.getAccString()
                
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

