//
//  Craft.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

protocol Craft {
    var name: String    { get }
    var url: URL        { get }
    var lengthString: String    { get }
    var length: Double? { get }
    
    
    
}

