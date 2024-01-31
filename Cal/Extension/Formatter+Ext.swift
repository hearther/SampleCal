//
//  Formatter+Ext.swift
//  Cal
//
//  Created by Bunny Lin on 2024/1/30.
//
//

import UIKit

extension Formatter {
    static let withCommaSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
