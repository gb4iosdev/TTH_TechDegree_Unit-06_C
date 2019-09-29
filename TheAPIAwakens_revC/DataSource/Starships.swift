//
//  Starships.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 26-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Structure to capture all starships from API
struct Starships: Codable {
    let results: [Starship]  //Header information captured only
    let next: URL?
    
    static var allEntities: [Starship] = []
    
    enum CodingKeys: String, CodingKey {
        case results
        case next
    }
}
