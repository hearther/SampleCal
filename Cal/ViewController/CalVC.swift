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





class CalVC: UIViewController {
    @IBOutlet var containV1: UIView!
    var cal1: CalView?
    @IBOutlet var containV2: UIView!
    var cal2: CalView?
    
    @IBOutlet var toL: UIButton!
    @IBOutlet var toR: UIButton!
    @IBOutlet var del: UIButton!
    
    @IBOutlet var btns : [UIButton] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let c1 = UINib(nibName:"CalView",bundle:.main).instantiate(withOwner: nil, options: nil).first as? CalView,
            let c2 = UINib(nibName:"CalView",bundle:.main).instantiate(withOwner: nil, options: nil).first as? CalView else
        {
            return
        }
        
        self.cal1 = c1
        c1.frame = self.containV1.bounds
        self.containV1.addSubview(c1)
        
        
        self.cal2 = c2
        c2.frame = self.containV2.bounds
        self.containV2.addSubview(c2)
        
        for btn in btns {
            btn.layer.cornerRadius = min(20, max(btn.frame.height/4, 5));
            //adjust text to btn width
            btn.titleLabel?.numberOfLines = 1
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.titleLabel?.lineBreakMode = .byClipping
            btn.titleLabel?.textAlignment = .center
        }
    }
    override func viewLayoutMarginsDidChange() {
        for btn in btns {
            btn.layer.cornerRadius = min(20, max(btn.frame.height/4, 5));
        }
    }
    
    //MARK: button action
    @IBAction func tapToL(){
        self.cal1?.handleTransferFromAnotherCal(self.cal2?.getCurAcc() ?? "")
        
    }
    
    @IBAction func tapToR(){
        self.cal2?.handleTransferFromAnotherCal(self.cal1?.getCurAcc() ?? "")
    }
    
    @IBAction func tapDEL(){
        self.cal1?.clear()
        self.cal2?.clear()
    }
}

