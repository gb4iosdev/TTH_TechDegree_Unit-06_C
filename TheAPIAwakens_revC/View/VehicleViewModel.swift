//
//  CraftViewModel.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct VehicleViewModel: EntityViewModel {
    
    let name: String
    
    let row1: String    //Make
    let row2: String    //Cost
    let row3: String    //Length
    let row4: String    //Class
    let row5: String    //Crew
    
}

extension VehicleViewModel {
    
    init?(from vehicle: Vehicle) {
        
        name = vehicle.name
        self.row3 = MeasureFormatter.formatLength(vehicle.length)
        
        if let detail = vehicle.detail {
            self.row1 = detail.make
            self.row4 = detail.craftClass
            self.row5 = detail.crewCapacity
            self.row2 = MeasureFormatter.formatCost(detail.cost)
        } else {
            return nil
        }
    }
}
