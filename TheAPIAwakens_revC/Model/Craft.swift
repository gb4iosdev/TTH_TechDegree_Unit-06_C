//
//  Craft.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 12-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

protocol Craft {
    var name: String { get }
    var url: URL { get }
    var length: Double? { get }
    var make: String { get }
    var cost: Int? { get }
    var craftClass: String { get }
    var crewCapacity: String { get }
    var craftType: CraftType { get }
}
