//
//  MeasureFormatter.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 04-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Static functions for cost and measurement conversions and formatting.
class MeasureFormatter {
    
    //Format and convert (if required) the cost based on currency selected
    static func formatCost(_ cost: Int?, in currency: Currency) -> String {
        
        guard var cost = cost else { return "Unknown" }
        
        //Formatter object parameters:
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.usesSignificantDigits = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        //Convert currency if required:
        if currency == .usd {
            cost = cost * Currency.usd.rawValue
        }
        
        //Format the cost based on magnitude:
        switch cost {
        case 0..<10_000:
            return formatter.string(from: NSNumber(value: cost)) ?? ""
        case 10_000..<1_000_000:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000)) ?? "") K")
        case 1_000_000..<1_000_000_000:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000_000)) ?? "") M")
        case 1_000_000_000..<1_000_000_000_000:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000_000_000)) ?? "") B")
        default:
            return ("\(formatter.string(from: NSNumber(value: cost/1_000_000_000_000)) ?? "") T")
        }
    }
    
    //Format and convert (if required) length measurements based on measurement type selected
    static func formatLength(_ length: Double?, measureType: MeasureType) -> String {
        
        guard let length = length else { return "Unknown" }
        
        switch measureType {
        case .metric:
            if length < 1000.0 {
                return Measurement(value: length, unit: UnitLength.meters).description
            } else {
                return Measurement(value: length, unit: UnitLength.meters).converted(to: UnitLength.kilometers).description
            }
        case .imperial:
            if length < 3.0 {
                let lengthMetres = Measurement(value: length, unit: UnitLength.meters)
                let lengthFeet = lengthMetres.converted(to: UnitLength.feet)
                let inches = ceil((lengthFeet.value - floor(lengthFeet.value))*12)
                let feet = floor(lengthFeet.value)
                return "\(Int(feet))' \(Int(inches))\""
            } else if length < 1610.0 {    //Number of metres in a mile
                return (String(format: "%.2f", Measurement(value: length, unit: UnitLength.meters).converted(to: UnitLength.yards).value)) + " yd"
            } else {
                return (String(format: "%.2f", Measurement(value: length, unit: UnitLength.meters).converted(to: UnitLength.miles).value)) + " mi"
            }
        }
        
    }
}
