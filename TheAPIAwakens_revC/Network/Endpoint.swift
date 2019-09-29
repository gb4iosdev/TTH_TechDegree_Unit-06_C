//
//  Endpoint.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 20-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//This type deals with constructing the URL (API end point)
enum Endpoint: String {
    case character = "people/1/"
    case vehicle = "vehicles/14/"
    case peopleLastPage = "people/?page=9"
    
    //for all entity retrievals:
    case people = "people/"
    case vehicles = "vehicles/"
    case starships = "starships/"
    
    func fullURL() -> URL? {
        let base = "https://swapi.co/api/"
        return URL(string: base + self.rawValue)
    }
}
