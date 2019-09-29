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
        
    }

}

extension StartScreenController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row selected is: \(indexPath.row)")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Get the destination view controller - only if the right type
        guard let detailController = segue.destination as? EntityDetailController else { return }
        
        //set the type of entities to load
        if let segueIdentifier = segue.identifier, let allEntityType = AllEntities(rawValue: segueIdentifier) {
            detailController.allEntities = allEntityType
        }
    }
    
}
