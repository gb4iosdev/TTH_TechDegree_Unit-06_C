//
//  CharacterHeader.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 22-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct Character: Codable {
    let name: String
    let url: URL
    private let heightString: String
    var height: Double? {
        return Double(heightString)
    }
    
    var detail: CharacterDetail?
    
    enum CodingKeys: String, CodingKey {
        case name
        case heightString = "height"
        case url
    }
}
