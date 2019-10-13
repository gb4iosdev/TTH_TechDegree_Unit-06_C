//
//  CraftViewModel.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 12-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Used to map between model object and UI
struct CraftViewModel: EntityViewModel {
    
    let name: String
    
    let row1: String    //Make
    let row2: String    //Cost
    let row3: String    //Length
    let row4: String    //Class
    let row5: String    //Crew
    
}

extension CraftViewModel {
    
    //Failable initializer to convert from model object to view model
    init?(from craft: Craft, with measuretype: MeasureType, in currency: Currency) {
        
        name = craft.name
        self.row3 = MeasureFormatter.formatLength(craft.length, measureType: measuretype)
        self.row1 = craft.make
        self.row4 = craft.craftClass.capitalized
        self.row5 = craft.crewCapacity
        self.row2 = MeasureFormatter.formatCost(craft.cost, in: currency)
    }
}
