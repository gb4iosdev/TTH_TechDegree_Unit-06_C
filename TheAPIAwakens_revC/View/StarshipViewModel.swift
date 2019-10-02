//
//  StarshipViewModel.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 01-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

import Foundation

struct StarshipViewModel: EntityViewModel {
    
    let name: String
    
    let row1: String    //Make
    let row2: String    //Cost
    let row3: String    //Length
    let row4: String    //Class
    let row5: String    //Crew
    
}

extension StarshipViewModel {
    
    init?(from starship: Starship) {
        
        name = starship.name
        if let length = starship.length {
            self.row3 = String(length) + "m"  //Need Conversion here
        } else {
            self.row3 = "Unknown"
        }
        
        if let detail = starship.detail {
            self.row1 = detail.make
            self.row4 = detail.craftClass
            self.row5 = detail.crewCapacity
            self.row2 = detail.cost
        } else {
            return nil
        }
    }
}
