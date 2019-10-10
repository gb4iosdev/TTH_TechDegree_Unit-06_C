//
//  CurrencyType.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 06-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Currency type and it's conversion from Galactic Credits
struct CurrencyExchange {
    private static let credits: Double = 1
    private static var usd: Double = 400
    
    static func usdDescription() -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .currency
//        let formattedNumber = numberFormatter.string(from: NSNumber(value: self.usd))
        return String(usd)
    }
    
    static func usdRate() -> Double {
        return self.usd
    }
    
    static func setCurrency(to value: Double) {
        self.usd = value
    }
}

