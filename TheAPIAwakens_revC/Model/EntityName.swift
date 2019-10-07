//
//  Planet.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Simple structure to capture the character’s homeworld's name, or the piloted craft names in a network call.
struct EntityName: Codable {
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
