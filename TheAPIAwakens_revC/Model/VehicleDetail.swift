//
//  VehicleDetail.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 28-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct VehicleDetail: Codable {
    
    let name: String
    let make: String
    let cost: String
    let length: String
    let craftClass: String
    let crewCapacity: String
    let craftType: CraftType = .vehicle
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case make = "model"
        case cost = "cost_in_credits"
        case length
        case craftClass = "vehicle_class"
        case crewCapacity = "crew"
        case url
    }
}
