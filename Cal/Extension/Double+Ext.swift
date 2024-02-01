//
//  Double+Ext.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/30.
//
//

import UIKit

extension Double {
    func formatCommaStr() -> String? {
        guard !self.isInfinite && !self.isNaN else {
            return nil
        }
        var ret:String? = nil
        if self == floor(self){
            //int
            ret = Formatter.withCommaSeparator.string(for: Int(self))
        }
        else {
            ret = String(self)
        }
        return ret
        
    }
}
