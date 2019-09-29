//
//  VehicleHeader.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 25-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct VehicleHeader: Codable {
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
