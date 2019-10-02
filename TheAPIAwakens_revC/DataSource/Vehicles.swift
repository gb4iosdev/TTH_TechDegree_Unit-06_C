//
//  Vehicles.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 26-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Structure to capture all vehicles from API
struct Vehicles: Codable {
    let results: [Vehicle]   //Header information captured only
    let next: URL?
    
    static var allEntities: [Vehicle] = []
    static var minimumLengthCraftIndex: Int? = nil
    static var maximumLengthCraftIndex: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case results
        case next
    }
    
    static func configure() {
        
        guard allEntities.count > 0 else { return }
        
        //Determine max and min heights
        let sortedByLengths = self.allEntities.filter{ $0.length != nil }.sorted(by: { $0.length! < $1.length! })
        
        //Sort the allEntities array by name:
        allEntities.sort(by: { $0.name < $1.name})
        
        //Get the index of shortest and tallest and assign to static stored properties
        minimumLengthCraftIndex = allEntities.firstIndex(where: { $0.name == sortedByLengths.first?.name } )
        maximumLengthCraftIndex = allEntities.firstIndex(where: { $0.name == sortedByLengths.last?.name } )
    }

}
