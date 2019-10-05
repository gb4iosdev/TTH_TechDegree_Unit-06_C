//
//  AllEntities.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 28-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Note - raw value used for segue matching!
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
