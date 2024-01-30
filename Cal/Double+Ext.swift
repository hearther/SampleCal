//
//  Double+Ext.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/30.
//
//

import UIKit

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
