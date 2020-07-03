//
//  CurrencyUtils.swift
//  BattleBuddy
//
//  Created by Veritas on 6/29/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import Foundation

protocol Currency {
    func roublesString() -> String
}

extension Int: Currency {
    func roublesString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(integerLiteral: self)) ?? ""
    }
}
