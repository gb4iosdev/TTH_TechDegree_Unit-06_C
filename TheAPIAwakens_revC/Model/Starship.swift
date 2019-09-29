//
//  Starship.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 16-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

struct Starship: Codable {
    
    let name: String
    let make: String
    let cost: String
    let length: String
    let craftClass: String
    let crewCapacity: String
    let craftType: CraftType = .starship
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case make = "model"
        case cost = "cost_in_credits"
        case length
        case craftClass = "starship_class"
        case crewCapacity = "crew"
        case url
    }
    
    func fetchDetail() {
        
    }
    
    /*
     
     {
     "name": "Death Star",
     "model": "DS-1 Orbital Battle Station",
     "manufacturer": "Imperial Department of Military Research, Sienar Fleet Systems",
     "cost_in_credits": "1000000000000",
     "length": "120000",
     "max_atmosphering_speed": "n/a",
     "crew": "342953",
     "passengers": "843342",
     "cargo_capacity": "1000000000000",
     "consumables": "3 years",
     "hyperdrive_rating": "4.0",
     "MGLT": "10",
     "starship_class": "Deep Space Mobile Battlestation",
     "pilots": [],
     "films": [
     "https://swapi.co/api/films/1/"
     ],
     "created": "2014-12-10T16:36:50.509000Z",
     "edited": "2014-12-22T17:35:44.452589Z",
     "url": "https://swapi.co/api/starships/9/"
     }
     
    */
    
}


/*

 Schema:
 
 {
 "title": "Starship",
 "required": [
 "name",
 "model",
 "manufacturer",
 "cost_in_credits",
 "length",
 "max_atmosphering_speed",
 "crew",
 "passengers",
 "cargo_capacity",
 "consumables",
 "hyperdrive_rating",
 "MGLT",
 "starship_class",
 "pilots",
 "films",
 "created",
 "edited",
 "url"
 ],
 "properties": {
 "max_atmosphering_speed": {
 "type": "string",
 "description": "The maximum speed of this starship in atmosphere. n/a if this starship is incapable of atmosphering flight."
 },
 "crew": {
 "type": "string",
 "description": "The number of personnel needed to run or pilot this starship."
 },
 "pilots": {
 "type": "array",
 "description": "An array of People URL Resources that this starship has been piloted by."
 },
 "created": {
 "format": "date-time",
 "type": "string",
 "description": "The ISO 8601 date format of the time that this resource was created."
 },
 "model": {
 "type": "string",
 "description": "The model or official name of this starship. Such as T-65 X-wing or DS-1 Orbital Battle Station."
 },
 "MGLT": {
 "type": "string",
 "description": "The Maximum number of Megalights this starship can travel in a standard hour. A Megalight is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth."
 },
 "starship_class": {
 "type": "string",
 "description": "The class of this starship, such as Starfighter or Deep Space Mobile Battlestation."
 },
 "films": {
 "type": "array",
 "description": "An array of Film URL Resources that this starship has appeared in."
 },
 "edited": {
 "format": "date-time",
 "type": "string",
 "description": "the ISO 8601 date format of the time that this resource was edited."
 },
 "name": {
 "type": "string",
 "description": "The name of this starship. The common name, such as Death Star."
 },
 "cost_in_credits": {
 "type": "string",
 "description": "The cost of this starship new, in galactic credits."
 },
 "hyperdrive_rating": {
 "type": "string",
 "description": "The class of this starships hyperdrive."
 },
 "manufacturer": {
 "type": "string",
 "description": "The manufacturer of this starship. Comma seperated if more than one."
 },
 "cargo_capacity": {
 "type": "string",
 "description": "The maximum number of kilograms that this starship can transport."
 },
 "length": {
 "type": "string",
 "description": "The length of this starship in meters."
 },
 "consumables": {
 "type": "string",
 "description": "The maximum length of time that this starship can provide consumables for its entire crew without having to resupply."
 },
 "url": {
 "format": "uri",
 "type": "string",
 "description": "The hypermedia URL of this resource."
 },
 "passengers": {
 "type": "string",
 "description": "The number of non-essential people this starship can transport."
 }
 },
 "type": "object",
 "description": "A Starship",
 "$schema": "http://json-schema.org/draft-04/schema"
 }
 
*/
