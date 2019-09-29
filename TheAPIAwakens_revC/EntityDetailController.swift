//
//  EntityDetailController.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 28-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class EntityDetailController: UITableViewController {
    
    var allEntities: AllEntities?
    let client = StarWarsAPIClient()

    //Outlet variables
    @IBOutlet weak var entityPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let entitiesToLoad = allEntities else {
            print("cannot load entities")
            return
        }
        
        entityPicker.delegate = self
        entityPicker.dataSource = self

        fetchEntities(entitiesToLoad: entitiesToLoad)
        
    }
    

}



//Pickerview delegation and datasource

extension EntityDetailController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let entities = self.allEntities else { return 0 }
        
        switch entities {
        case .Characters:   return People.allEntities.count
        case .Vehicles:     return Vehicles.allEntities.count
        case .Starships:    return Starships.allEntities.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let entities = self.allEntities else { return "" }
        
        switch entities {
        case .Characters:   return People.allEntities[row].name
        case .Vehicles:     return Vehicles.allEntities[row].name
        case .Starships:    return Starships.allEntities[row].name
        }
        
    }
    
    
}

//Helper Methods
extension EntityDetailController {
    
    func fetchEntities(entitiesToLoad allEntities: AllEntities) {
        
        switch allEntities {
        case .Characters:
            if People.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.people.fullURL(), toType: People.self)
            } else {
                entityPicker.reloadAllComponents()
            }
        case .Vehicles:
            if Vehicles.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.vehicles.fullURL(), toType: Vehicles.self)
            } else {
                entityPicker.reloadAllComponents()
            }
        case .Starships:
            if Starships.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.starships.fullURL(), toType: Starships.self)
            } else {
                entityPicker.reloadAllComponents()
            }
        }
        
    }
    
    func retrieveAllEntities<T: Codable>(using thisURL: URL?, toType type: T.Type) {
        
        var nextURL: URL?
        
        if thisURL == nil {
            return
        } else {    //Make network call using API client with the URL
            client.getStarWarsData(from: thisURL, toType: T.self) { [unowned self] entities, error in
                if let entities = entities {
                    //Append entity to the type’s static data source variable
                    if let allEntities = entities as? People {
                        People.allEntities.append(contentsOf: allEntities.results)
                        nextURL = allEntities.next
                    } else if let allEntities = entities as? Vehicles {
                        Vehicles.allEntities.append(contentsOf: allEntities.results)
                        nextURL = allEntities.next
                    } else if let allEntities = entities as? Starships {
                        Starships.allEntities.append(contentsOf: allEntities.results)
                        nextURL = allEntities.next
                    }
                    
                    //Check if there is a next page, and that it can be created into an URL.  If so, call this method again.
                    if let nextURL = nextURL {
                        self.retrieveAllEntities(using: nextURL, toType: type)
                    } else {        //Final page and allEntity static arrays are loaded.  Reload the picker.
                        self.entityPicker.reloadAllComponents()
                    }
                } else {
                    print("Error in retrieveStarWarsPage is: \(error)")     ///Create an alert here??
                }
            }
        }
    }

}
