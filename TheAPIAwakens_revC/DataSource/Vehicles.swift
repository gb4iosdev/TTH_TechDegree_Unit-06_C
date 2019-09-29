//
//  Vehicles.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 26-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Structure to capture all vehicles from API
struct Vehicles: Codable {
    let results: [Vehicle]   //Header information captured only
    let next: URL?
    
    static var allEntities: [Vehicle] = []
    
    enum CodingKeys: String, CodingKey {
        case results
        case next
    }
}
