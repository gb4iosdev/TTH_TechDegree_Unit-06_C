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
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var mainRowLabels: [UILabel]!
    @IBOutlet var mainRowFields: [UILabel]!
    
    @IBOutlet weak var pilotsCell: UITableViewCell!
    @IBOutlet weak var pilotsLabel: UILabel!
    
    @IBOutlet weak var entityPicker: UIPickerView!
    @IBOutlet weak var shortestButton: UIButton!
    @IBOutlet weak var tallestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let entitiesToLoad = allEntities else {
            print("cannot load entities")
            return
        }
        
        entityPicker.delegate = self
        entityPicker.dataSource = self
        
        //navigationController?.navigationBar.barStyle = .black
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 32)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs

        if let navBarItem = navigationController?.navigationBar.topItem {
            navBarItem.title = "Characters"
        }
        //self.navigationItem.titleView = UIImageView(image: UIImage(named: "icon-characters"))
        
        pilotsCell.accessoryType = .none
        
        
        setFieldLabels()
        fetchEntities(entitiesToLoad: entitiesToLoad)
        
    }
    
    @IBAction func shortestButtonPressed(_ sender: Any) {
        if let minimumHeightCharacterIndex = People.minimumHeightCharacterIndex {
            entityPicker.selectRow(minimumHeightCharacterIndex, inComponent: 0, animated: true)
            setFieldValues(for: minimumHeightCharacterIndex)
        }
    }
    
    @IBAction func tallestButtonPressed(_ sender: Any) {
        if let maximumHeightCharacterIndex = People.maximumHeightCharacterIndex {
            entityPicker.selectRow(maximumHeightCharacterIndex, inComponent: 0, animated: true)
            setFieldValues(for: maximumHeightCharacterIndex)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Need to cancel the network request if the user navigates off this ViewController before the network call is finished.
        client.session.invalidateAndCancel()
    }
    
}

//MARK: Tableview delegation

extension EntityDetailController {
    
    //Set section gaps between sections to 0.01 (setting to 0 will revert to default)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}



//MARK: Pickerview delegation & data source

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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Picker picked")
        setFieldValues(for: row)
    }
    
    
}

//Helper Methods - Networking
extension EntityDetailController {
    
    func fetchEntities(entitiesToLoad allEntities: AllEntities) {
        
        switch allEntities {
        case .Characters:
            if People.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.people.fullURL(), toType: People.self)
            } else {
                entityPicker.reloadAllComponents()
                self.updateUI()
            }
        case .Vehicles:
            if Vehicles.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.vehicles.fullURL(), toType: Vehicles.self)
            } else {
                entityPicker.reloadAllComponents()
                self.updateUI()
            }
        case .Starships:
            if Starships.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.starships.fullURL(), toType: Starships.self)
            } else {
                entityPicker.reloadAllComponents()
                self.updateUI()
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
                        People.configure()
                        self.entityPicker.reloadAllComponents()
                        self.updateUI()
                    }
                } else {
                    print("Error in retrieveStarWarsPage is: \(error)")     ///Create an alert here??
                }
            }
        }
    }

}

//MARK: - Helper Methods - UI
extension EntityDetailController {
    
    func updateUI(){
        
        //Set the field labels for the entities type being displayed
        setFieldLabels()
        
        //Set the shortest/tallest buttons
        if let minimumHeightCharacterIndex = People.minimumHeightCharacterIndex, let maximumHeightCharacterIndex = People.maximumHeightCharacterIndex {
            shortestButton.setTitle(People.allEntities[minimumHeightCharacterIndex].name, for: .normal)
            tallestButton.setTitle(People.allEntities[maximumHeightCharacterIndex].name, for: .normal)
        }
        
        //Set field values for the picker default row
        setFieldValues(for: 0)
    }
    
    func setFieldLabels() {
        
        guard let entities = self.allEntities else { return }
        
        switch entities {
        case .Characters:
            mainRowLabels?[CharacterLabel.born.rawValue].text = CharacterLabel.born.text()
            mainRowLabels?[CharacterLabel.home.rawValue].text = CharacterLabel.home.text()
            mainRowLabels?[CharacterLabel.height.rawValue].text = CharacterLabel.height.text()
            mainRowLabels?[CharacterLabel.eyes.rawValue].text = CharacterLabel.eyes.text()
            mainRowLabels?[CharacterLabel.hair.rawValue].text = CharacterLabel.hair.text()
        case .Vehicles, .Starships:
            mainRowLabels?[CraftLabel.make.rawValue].text = CraftLabel.make.text()
            mainRowLabels?[CraftLabel.cost.rawValue].text = CraftLabel.cost.text()
            mainRowLabels?[CraftLabel.length.rawValue].text = CraftLabel.length.text()
            mainRowLabels?[CraftLabel.class.rawValue].text = CraftLabel.class.text()
            mainRowLabels?[CraftLabel.crew.rawValue].text = CraftLabel.crew.text()
        }
    }
    
    //set field values based on entity picked
    func setFieldValues(for pickerRowNumber: Int) {
        
        guard let entities = self.allEntities else { return }
        
        
        switch entities {
        case .Characters:
            var character = People.allEntities[pickerRowNumber]
            //Check to see if the character detail is missing
            if character.detail == nil {
                client.getStarWarsData(from: character.url, toType: CharacterDetail.self) { [unowned self] characterDetail, error in
                    if let characterDetail = characterDetail {
                        character.detail = characterDetail
                        //Write back to the allEntities static array
                        People.allEntities[pickerRowNumber] = character
                        if let viewModel = CharacterViewModel(from: character) {
                            self.setFieldValues(using: viewModel)
                        } else {
                            print("Error: Could not create view model")
                        }
                    } else {
                        print("Network call didn't work:\(error)")
                    }
                }
            } else {    //Data exists - simply load
                print("Data already exists for \(character.name) - no need for network call")
                if let viewModel = CharacterViewModel(from: character) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }

            
        case .Vehicles:
            break
        case .Starships:
            break
        }
    
    }
    
    func setFieldValues(using viewModel: EntityViewModel) {
        headerLabel.text = viewModel.name
        mainRowFields[0].text = viewModel.row1
        mainRowFields[1].text = viewModel.row2
        mainRowFields[2].text = viewModel.row3
        mainRowFields[3].text = viewModel.row4
        mainRowFields[4].text = viewModel.row5
    }
}
