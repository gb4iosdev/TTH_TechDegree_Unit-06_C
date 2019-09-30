//
//  PilotedCraftController.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 30-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class PilotedCraftController: UITableViewController {
    
    let client = StarWarsAPIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillDisappear(_ animated: Bool) {
        //Need to cancel the network request if the user navigates off this ViewController before the network call is finished.
        client.session.invalidateAndCancel()
    }
}
