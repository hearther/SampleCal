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


class CalVC: UIViewController {
    @IBOutlet var cal1: UIView!
    @IBOutlet var cal2: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var c = UINib(nibName:"CalView",bundle:.main).instantiate(withOwner: nil, options: nil).first as! CalView
        c.frame = self.cal1.bounds
        self.cal1.addSubview(c)
        
        c = UINib(nibName:"CalView",bundle:.main).instantiate(withOwner: nil, options: nil).first as! CalView
        c.frame = self.cal2.bounds
        self.cal2.addSubview(c)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onOrientationChange(_ notif:Notification) {
        let orientation = UIDevice.current.orientation
        print("Recieved On Orientation Change with orientation : \(orientation)")
    }
}

