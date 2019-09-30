//
//  People.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 22-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Structure to capture all Characters from API
struct People: Codable {
    let results: [Character]
    let next: URL?
    
    static var allEntities: [Character] = []
    static var minimumHeightCharacterIndex: Int? = nil
    static var maximumHeightCharacterIndex: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case results
        case next
    }
    
    static func configure() {
        
        guard allEntities.count > 0 else { return }
        
        //Determine max and min heights
        let sortedByHeights = self.allEntities.filter{ $0.height != nil }.sorted(by: { $0.height! < $1.height! })
        
        //Sort the allEntities array by name:
        allEntities.sort(by: { $0.name < $1.name})
        
        //Get the index of shortest and tallest and assign to static stored properties
        minimumHeightCharacterIndex = allEntities.firstIndex(where: { $0.name == sortedByHeights.first?.name } )
        maximumHeightCharacterIndex = allEntities.firstIndex(where: { $0.name == sortedByHeights.last?.name } )
    }
}
