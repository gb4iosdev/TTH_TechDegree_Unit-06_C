//
//  CharacterViewModel.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Used to map between model object and UI
struct CharacterViewModel: EntityViewModel {
    
    let name: String
    
    let row1: String    //Birthyear
    let row2: String    //Home
    let row3: String    //Height
    let row4: String    //Eyes
    let row5: String    //Hair
    
    let hasPilotedCraft: Bool   //Indicates whether to show/hide the disclosure indicator for piloted craft detail.
}

extension CharacterViewModel {
    
    //Failable initializer to convert from model object to view model
    init?(from character: Character, with measureType: MeasureType) {
        
        name = character.name
        
        self.row3 = MeasureFormatter.formatLength(character.height, measureType: measureType)

        if let detail = character.detail {
            self.row1 = detail.birthYear
            self.row4 = detail.eyeColour
            self.row5 = detail.hairColour
            self.row2 = detail.home ?? ""
            self.hasPilotedCraft = detail.vehiclesPiloted.count > 0 || detail.starshipsPiloted.count > 0
            
        } else {
            return nil
        }
    }
}

