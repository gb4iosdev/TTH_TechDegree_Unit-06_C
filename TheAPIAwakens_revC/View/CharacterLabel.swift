//
//  CharacterLabel.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 29-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Integer corresponds to the array index in the outlet collection mainRowLabels
enum CharacterLabel: Int {
    case born
    case home
    case height
    case eyes
    case hair
    
    func text() -> String {
        switch self {
        case .born: return "Born"
        case .home: return "Home"
        case .height: return "Height"
        case .eyes: return "Eyes"
        case .hair: return "Hair"
        }
    }
}
