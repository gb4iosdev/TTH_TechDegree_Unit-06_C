//
//  StarWarsAPIError.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 20-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Error types for network calls to Star Wars API
enum StarWarsAPIError: Error {
    
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
    case noDataReturnedFromDataTask(detail: String)
}
