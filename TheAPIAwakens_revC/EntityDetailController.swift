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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let entitiesToLoad = allEntities else {
            print("cannot load entities")
            return
        }

        fetchEntitiesIfRequired(entitiesToLoad: entitiesToLoad)
        
    }
    

}

//Helper Methods
extension EntityDetailController {
    
    func fetchEntitiesIfRequired(entitiesToLoad allEntities: AllEntities) {
        switch 
    }
}
