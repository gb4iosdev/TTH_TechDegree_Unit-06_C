//
//  CraftViewModel.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Used to map between model object and UI
struct VehicleViewModel: EntityViewModel {
    
    let name: String
    
    let row1: String    //Make
    let row2: String    //Cost
    let row3: String    //Length
    let row4: String    //Class
    let row5: String    //Crew
    
}

extension VehicleViewModel {
    
    //Failable initializer to convert from model object to view model
    init?(from vehicle: Vehicle, with measureType: MeasureType, in currency: Currency) {
        
        name = vehicle.name
        self.row3 = MeasureFormatter.formatLength(vehicle.length, measureType: measureType)
        
        if let detail = vehicle.detail {
            self.row1 = detail.make
            self.row4 = detail.craftClass.capitalized
            self.row5 = detail.crewCapacity
            self.row2 = MeasureFormatter.formatCost(detail.cost, in: currency)
        } else {
            return nil
        }
    }
}
