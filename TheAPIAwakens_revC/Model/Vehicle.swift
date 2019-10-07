//
//  Vehicle.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Single vehicle header information.  Enough to populate the picker and enable longest/shortest length determination.
struct Vehicle: Codable {
    
    let name: String
    let url: URL
    private let lengthString: String
    var length: Double? {
        return Double(lengthString)
    }
    
    //Populated via separate network call if vehicle is picked in the picker for detailed display.
    var detail: VehicleDetail?
    
    enum CodingKeys: String, CodingKey {
        case name
        case lengthString = "length"
        case url
    }
}

  
