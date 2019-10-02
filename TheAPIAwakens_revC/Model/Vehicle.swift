//
//  Vehicle.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct Vehicle: Codable {
    
    let name: String
    let url: URL
    private let lengthString: String
    var length: Double? {
        return Double(lengthString)
    }
    
    var detail: VehicleDetail?
    
    enum CodingKeys: String, CodingKey {
        case name
        case lengthString = "length"
        case url
    }
}

  
