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
    var character: Character?
    var pickerIndex: Int?                   //For writing the data back to the People static array
    
    var allExpectedFetches: Int?
    var allActualFetches = 0
    
    var sectionData = [["<None Piloted>"], ["<None Piloted>"]]
    let sectionTitles = ["Vehicles", "Starships"]
    let sectionImage: [UIImage] = [UIImage(named: "icon-vehicles")!, UIImage(named: "icon-starships")!]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Character is:\(character)")
        print("Character detail is:\(character?.detail)")
        print("pickerIndex is:\(pickerIndex)")
        
        guard let character = character, let detail = character.detail, let pickerIndex = pickerIndex else {
            print("Error:  Character not loaded")
            return
        }
        
        if character.hasAlreadyFetchedCraft() {
            sectionData[0] = detail.vehicleNames ?? []
            sectionData[1] = detail.starshipNames ?? []
        } else {          //Need a network call
            self.allExpectedFetches = detail.vehiclesPiloted.count + detail.starshipsPiloted.count
            print(detail.vehiclesPiloted)
            print(detail.starshipsPiloted)
            fetchCraftForCharacter(using: detail.vehiclesPiloted, for: CraftType.vehicle)
            fetchCraftForCharacter(using: detail.starshipsPiloted, for: CraftType.starship)
        }
        
        
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        //Need to cancel the network request if the user navigates off this ViewController before the network call is finished.
//        client.session.invalidateAndCancel()
//    }
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
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        
        let imageView = UIImageView(image: sectionImage[section])
        imageView.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(imageView)
        
        let text = sectionTitles[section]
        let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [  .font: font,
                                                           .foregroundColor: UIColor(red:0.49, green:0.84, blue:1.00, alpha:1.0)
            
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "craftsPiloted")
        cell!.textLabel!.text = sectionData[indexPath.section][indexPath.row]
        return cell!
    }
    
    
}

//MARK: - Networking
extension PilotedCraftController {
    
    //Write a function that takes an array of URL's and makes network calls to populate an array of results (names) and knows when it has finished.
    //Use this for the exceeds requirement - to populate the assocated vehicles and starships.
    func fetchCraftForCharacter(using urls: [URL], for craftType: CraftType) {
        guard urls.count >= 1 else {
            switch  craftType {
            case .vehicle:
                sectionData[0] = ["<None Piloted>"]
            case .starship:
                sectionData[1] = ["<None Piloted>"]
            }
            return
        }
        
        let requiredFetches = urls.count
        var numberOfFetches = 0
        var nameArray: [String] = []
        
        for url in urls {
            client.getStarWarsData(from: url, toType: VehicleHeader.self) { [unowned self] vehicleHeader, error in
                if let vehicleHeader = vehicleHeader {
                    numberOfFetches += 1
                    self.allActualFetches += 1
                    nameArray.append(vehicleHeader.name)
                    if numberOfFetches == requiredFetches {
                        //Save this array to the class variable:
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
                    print("didn't work:\(error)")
                }
            }
        }
    }
    
}

