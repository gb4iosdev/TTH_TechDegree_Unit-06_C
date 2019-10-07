//
//  PilotedCraftController.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 30-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class PilotedCraftController: UITableViewController {
    
    let client = StarWarsAPIClient()        //Networking
    var character: Character?               //Characted selected in previous table view
    
    //Network calls dispatched all at once.  Need to track when final call has completed
    var allExpectedFetches: Int?
    var allActualFetches = 0
    
    var sectionData = [[""], [""]]
    let sectionTitles = ["Vehicles", "Starships"]
    //Use icon images for section headers
    let sectionImage: [UIImage] = [UIImage(named: "icon-vehicles")!, UIImage(named: "icon-starships")!]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //At a minimum need a character and it's detail to be popuolated to proceed
        guard let character = character, let detail = character.detail else {
            print("Error:  Character not loaded")
            return
        }
        
        initializeUI()      //Show character's name in nav bar title
        
        if character.hasAlreadyFetchedCraft() {         //Prevent un-needed network re-fetch.
            sectionData[0] = detail.vehicleNames ?? []
            sectionData[1] = detail.starshipNames ?? []
        } else {          //Need a network call
            //Calculate the expected number of fetches
            self.allExpectedFetches = detail.vehiclesPiloted.count + detail.starshipsPiloted.count
            //Network calls:
            fetchCraftForCharacter(using: detail.vehiclesPiloted, for: CraftType.vehicle)
            fetchCraftForCharacter(using: detail.starshipsPiloted, for: CraftType.starship)
        }
        
        
    }
    
    func initializeUI() {
        //Nav Bar title formatting.  Show character's name in nav bar title
        if let character = self.character {
            let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            let attributes: [NSAttributedString.Key: Any] = [  .font: font,
                                                               .foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = attributes
            self.title = character.name
        }
    }
}

//MARK: - Tableview datasource & delegate methods
extension PilotedCraftController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    //Set section gaps between sections to 0.01 (setting to 0 will revert to default)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    //Based on the section being demanded, populate the label & and image, add to view, return the view for the section.
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        
        //Add the image view:
        let imageView = UIImageView(image: sectionImage[section])
        imageView.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(imageView)
        
        //Setup attributed text parameters
        let text = sectionTitles[section]
        let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [  .font: font,
                                                           .foregroundColor: UIColor(red:0.49, green:0.84, blue:1.00, alpha:1.0)]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        //Create label, assign attributed text, add to view.
        let label = UILabel()
        label.attributedText = attributedText
        label.frame = CGRect(x: 45, y: 5, width: 200, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "craftsPiloted"), let textLabel = cell.textLabel {
            textLabel.text = sectionData[indexPath.section][indexPath.row]
            return cell
        } else {
            print("Error: failed to generate custom Crafts Piloted cell")
            return UITableViewCell()
        }
    }
    
    
}

//MARK: - Networking
extension PilotedCraftController {
    
    //Function takes an array of URL's and makes network calls to populate an array of results (names) and determines when it has finished.
    func fetchCraftForCharacter(using urls: [URL], for craftType: CraftType) {
        //If there are no URLs, populate some data indicating no crafts are piloted.
        guard urls.count >= 1 else {
            switch  craftType {
            case .vehicle:
                sectionData[0] = ["<None Piloted>"]
            case .starship:
                sectionData[1] = ["<None Piloted>"]
            }
            return
        }
        
        //Set fetch tracking variables
        let requiredFetches = urls.count
        var numberOfFetches = 0
        var nameArray: [String] = []
        
        for url in urls {
            client.getStarWarsData(from: url, toType: EntityName.self) { [unowned self] entity, error in
                if let entity = entity {
                    //Increment local & global fetches counters
                    numberOfFetches += 1
                    self.allActualFetches += 1
                    //Append name to local array
                    nameArray.append(entity.name)
                    //Check if this was the last fetch for this craft type:
                    if numberOfFetches == requiredFetches {
                        //Save this array to the class variable for later tableview retrieval:
                        switch  craftType {
                        case .vehicle:
                            self.sectionData[0] = nameArray
                        case .starship:
                            self.sectionData[1] = nameArray
                        }
                        //Check overall fetches to see if sections array can be written to
                        if self.allActualFetches == self.allExpectedFetches {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    print("Error: Fetch results could not be cast to type:\(String(describing: error))")
                }
            }
        }
    }
    
}

