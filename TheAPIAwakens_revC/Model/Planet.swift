//
//  Planet.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Structure to capture the character’s homeworld's name.
struct Planet: Codable {
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
