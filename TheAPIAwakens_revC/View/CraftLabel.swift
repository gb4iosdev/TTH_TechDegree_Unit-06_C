//
//  CraftLabel.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 29-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Integer corresponds to the array index in the outlet collection mainRowLabels
enum CraftLabel: Int {
    case make
    case cost
    case length
    case `class`
    case crew
    
    func text() -> String {
        switch self {
        case .make: return "Make"
        case .cost: return "Cost"
        case .length: return "Length"
        case .class: return "Class"
        case .crew: return "Crew"
        }
    }
}
