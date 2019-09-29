//
//  People.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 22-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Structure to capture all Characters from API
struct People: Codable {
    let results: [Character]
    let next: URL?
    
    static var allEntities: [Character] = []
    
    enum CodingKeys: String, CodingKey {
        case results
        case next
    }
}
