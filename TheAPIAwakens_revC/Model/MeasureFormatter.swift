//
//  MeasureFormatter.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 04-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

class MeasureFormatter {
    
    static func formatCost(_ cost: Int?) -> String {
        
        guard let cost = cost else { return "Unknown" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.usesSignificantDigits = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        switch cost {
        case 0..<10_000:
            
            return formatter.string(from: NSNumber(value: cost)) ?? ""
        case 10_000..<1_000_000:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000)) ?? "") K")
        case 1_000_000..<1_000_000_000:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000_000)) ?? "") M")
        default:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000_000_000)) ?? "") B")
        }
    }
    
    static func formatLength(_ length: Double?) -> String {
        
        guard let length = length else { return "Unknown" }
        if length < 1000.0 {
            return Measurement(value: length, unit: UnitLength.meters).description
        } else {
            return Measurement(value: length, unit: UnitLength.meters).converted(to: UnitLength.kilometers).description
        }
    }
}
