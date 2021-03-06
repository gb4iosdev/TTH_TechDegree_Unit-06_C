//
//  EntityViewModel.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 29-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//View Model parameters common to all.
protocol EntityViewModel {
    
    var name: String { get }
    
    var row1: String { get }
    var row2: String { get }
    var row3: String { get }
    var row4: String { get }
    var row5: String { get }
    
}
