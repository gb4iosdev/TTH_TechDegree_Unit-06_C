//
//  CharacterViewModel.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct CharacterViewModel: EntityViewModel {
    
    let row1: String    //Birthyear
    let row2: String    //Home
    let row3: String    //Height
    let row4: String    //Eyes
    let row5: String    //Hair
    
    let name: String
}

extension CharacterViewModel {
    
    init?(from character: Character) {
        
        name = character.name
        if let height = character.height {
            self.row3 = String(height/100) + "m"  //Need Conversion here
        } else {
            self.row3 = "Unknown"
        }
        
        if let detail = character.detail {
            self.row1 = detail.birthYear
            self.row4 = detail.eyeColour
            self.row5 = detail.hairColour
            self.row2 = detail.home ?? ""
            
        } else {
            return nil
        }
    }
}

