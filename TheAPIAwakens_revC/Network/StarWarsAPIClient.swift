//
//  StarWarsAPIClient.swift
//  theAPIAwakens
//
//  Created by Gavin Butler on 20-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

class StarWarsAPIClient {
    
    let decoder = JSONDecoder()
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getStarWarsData<T: Codable>(from endpoint: URL?, toType type: T.Type, completionHandler completion: @escaping (T?, Error?) -> Void) {
        
        guard let starWarsAPIURL = endpoint else {
            completion(nil, StarWarsAPIError.invalidURL)
            return
        }
        
        let request = URLRequest(url: starWarsAPIURL)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, StarWarsAPIError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let entity = try self.decoder.decode(type, from: data)
                            completion(entity, nil)
                            
                        } catch {
                            completion(nil, StarWarsAPIError.jsonParsingFailure)
                        }
                    } else {
                        completion(nil, StarWarsAPIError.responseUnsuccessful(statusCode: httpResponse.statusCode))
                    }
                } else if let error = error {
                    completion(nil, StarWarsAPIError.noDataReturnedFromDataTask(detail: error.localizedDescription))
                }
            }
        }
        
        task.resume()
    }
    
}
