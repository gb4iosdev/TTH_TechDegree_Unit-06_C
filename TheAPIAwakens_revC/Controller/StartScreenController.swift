//
//  StartScreenController.swift
//  TheAPIAwakens
//
//  Created by Gavin Butler on 27-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class StartScreenController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }

}

//MARK: Tableview delegation

extension StartScreenController {
    
    //Set section gaps between sections to 0.01 (setting to 0 will revert to default)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


extension StartScreenController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Get the destination view controller - only if the right type
        guard let detailController = segue.destination as? EntityDetailController else { return }
        
        //set the type of entities to load
        if let segueIdentifier = segue.identifier, let allEntityType = AllEntities(rawValue: segueIdentifier) {
            detailController.allEntities = allEntityType
        }
    }
    
}
