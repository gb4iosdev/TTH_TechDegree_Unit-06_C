//
//  StartScreenController.swift
//  TheAPIAwakens
//
//  Created by Gavin Butler on 27-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class StartScreenController: UITableViewController {
    
    //Store the calculated height for static cells, to allow for quick retrieval in height for row at indexPath.
    var rowHeightCalculation: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove the default 'Back' title from the Navigation Bar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Calculate height for rows
        rowHeightCalculation = heightForStaticCells()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeightCalculation     //Sets height for all cells.
    }
}

//MARK: Navigation
extension StartScreenController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Get the destination view controller - only if the right type (EntityDetailController)
        guard let detailController = segue.destination as? EntityDetailController else { return }
        
        //set the type of entities to load
        if let segueIdentifier = segue.identifier, let allEntityType = AllEntities(rawValue: segueIdentifier) {
            detailController.allEntities = allEntityType
        }
    }
    
}

//MARK: Helper Methods
extension StartScreenController  {
    
    func heightForStaticCells() -> CGFloat {
        let tableHeight = (tableView.bounds.height)
        
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        return (tableHeight - topPadding! - bottomPadding!-40)/3    //-40 to allow room for the home indicator.
    }
}
