//
//  CharacterHeader.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 22-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Single character header information.  Enough to populate the picker and enable tallest/shortest height determination.
struct Character: Codable {
    let name: String
    let url: URL
    private let heightString: String
    var height: Double? {
        if let height = Double(heightString) {
            return Double(height)/100.0
        } else {
            return nil
        }
    }
    
    //Populated via separate network call if character is picked in the picker for detailed display.
    var detail: CharacterDetail?
    
    enum CodingKeys: String, CodingKey {
        case name
        case heightString = "height"
        case url
    }
    
    func hasAlreadyFetchedCraft() -> Bool {
        if let detail = self.detail, detail.vehicleNames != nil,  detail.starshipNames  != nil {
            return true
        } else {
            return false
        }
    }

}
