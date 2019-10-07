//
//  AllEntities.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 28-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Type to keep track of user selection of entity - plural to refer to all entities.
//Note - do not change raw value - used for segue matching!
enum AllEntities: String {
    case characters
    case vehicles
    case starships
    
    func titleForNavigationBar() -> String {
        switch self {
        case .characters:  return "Characters"
        case .vehicles: return "Vehicles"
        case .starships: return "Starships"
        }
    }
}
