//
//  CraftViewModel.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct CraftViewModel {
    
    let name: String
    let make: String
    let cost: String
    let length: String
    let craftClass: String
    let crewCapacity: String
    let url: String
    
    init(from craft: Craft) {
        
        name = craft.name
        make = craft.make
        cost = String(craft.cost) //Need Conversion here
        length = String(craft.length)        //Need Conversion here
        craftClass = craft.craftClass
        crewCapacity = String(craft.crewCapacity)
        url = craft.url
    }
}
