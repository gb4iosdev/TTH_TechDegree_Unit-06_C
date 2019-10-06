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
    var entityPickerRowHeightCalculation: CGFloat = 0.0
    var measureType: MeasureType = .metric {
        didSet {
            conversionUpdate()
        }
    }

    //Outlet variables
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var mainRowLabels: [UILabel]!
    @IBOutlet var mainRowFields: [UILabel]!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    @IBOutlet weak var pilotsCell: UITableViewCell!
    @IBOutlet weak var pilotsLabel: UILabel!
    
    @IBOutlet weak var entityPicker: UIPickerView!
    @IBOutlet weak var shortestLabel: UILabel!
    @IBOutlet weak var shortestButton: UIButton!
    @IBOutlet weak var longestLabel: UILabel!
    @IBOutlet weak var longestButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let entitiesToLoad = allEntities else {
            print("Error: Entities not specified - cannot load entities")
            return
        }
        
        //Set Pickerview data source and delegate
        entityPicker.delegate = self
        entityPicker.dataSource = self
        
        initializeUI()
        setFieldLabels()
        fetchEntities(entitiesToLoad: entitiesToLoad)
        
    }
    
    @IBAction func shortestButtonPressed(_ sender: Any) {
        
        guard let entities = self.allEntities else { return }
        
        switch entities {
        case .characters:
            if let minimumHeightCharacterIndex = People.minimumHeightCharacterIndex {
                entityPicker.selectRow(minimumHeightCharacterIndex, inComponent: 0, animated: true)
                setFieldValues(for: minimumHeightCharacterIndex)
            }
        case .vehicles:
            if let minimumLengthVehicleIndex = Vehicles.minimumLengthCraftIndex {
                entityPicker.selectRow(minimumLengthVehicleIndex, inComponent: 0, animated: true)
                setFieldValues(for: minimumLengthVehicleIndex)
            }
        case .starships:
            if let minimumLengthStarshipIndex = Starships.minimumLengthCraftIndex {
                entityPicker.selectRow(minimumLengthStarshipIndex, inComponent: 0, animated: true)
                setFieldValues(for: minimumLengthStarshipIndex)
            }
        }
        
    }
    
    @IBAction func longestButtonPressed(_ sender: UIButton) {
        
        guard let entities = self.allEntities else { return }
        
        switch entities {
        case .characters:
            if let maximumHeightCharacterIndex = People.maximumHeightCharacterIndex {
                entityPicker.selectRow(maximumHeightCharacterIndex, inComponent: 0, animated: true)
                setFieldValues(for: maximumHeightCharacterIndex)
            }
        case .vehicles:
            if let maximumLengthVehicleIndex = Vehicles.maximumLengthCraftIndex {
                entityPicker.selectRow(maximumLengthVehicleIndex, inComponent: 0, animated: true)
                setFieldValues(for: maximumLengthVehicleIndex)
            }
        case .starships:
            if let maximumLengthStarshipIndex = Starships.maximumLengthCraftIndex {
                entityPicker.selectRow(maximumLengthStarshipIndex, inComponent: 0, animated: true)
                setFieldValues(for: maximumLengthStarshipIndex)
            }
        }
    }
    
    @IBAction func imperialButtonPressed(_ sender: UIButton) {
        measureType = .imperial
        imperialButton.setTitleColor(.lightGray, for: .normal)
        metricButton.setTitleColor(.white, for: .normal)
        imperialButton.isUserInteractionEnabled = false
        metricButton.isUserInteractionEnabled = true
    }
    
    @IBAction func metricButtonPressed(_ sender: Any) {
        measureType = .metric
        metricButton.setTitleColor(.lightGray, for: .normal)
        imperialButton.setTitleColor(.white, for: .normal)
        imperialButton.isUserInteractionEnabled = true
        metricButton.isUserInteractionEnabled = false
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        //Need to cancel the network request if the user navigates off this ViewController before the network call is finished.
//        client.session.invalidateAndCancel()
//    }
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1: return entityPickerRowHeightCalculation        //Entity Picker
        case 2: return 100.0        //Footer buttons
        default: return 45          //Top Data rows
        }
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
        case .characters:   return People.allEntities.count
        case .vehicles:     return Vehicles.allEntities.count
        case .starships:    return Starships.allEntities.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let entities = self.allEntities else { return "" }
        
        switch entities {
        case .characters:   return People.allEntities[row].name
        case .vehicles:     return Vehicles.allEntities[row].name
        case .starships:    return Starships.allEntities[row].name
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setFieldValues(for: row)
    }
}

//MARK: - Helper Methods - Networking
extension EntityDetailController {
    
    func fetchEntities(entitiesToLoad allEntities: AllEntities) {
        
        switch allEntities {
        case .characters:
            if People.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.people.fullURL(), toType: People.self)
            } else {
                entityPicker.reloadAllComponents()
                self.updateUI()
            }
        case .vehicles:
            if Vehicles.allEntities.count == 0 {
                retrieveAllEntities(using: Endpoint.vehicles.fullURL(), toType: Vehicles.self)
            } else {
                entityPicker.reloadAllComponents()
                self.updateUI()
            }
        case .starships:
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
                        if let allEntities = entities as? People {
                            People.configure()
                        }
                        else if let allEntities = entities as? Vehicles { Vehicles.configure()
                        } else if let allEntities = entities as? Starships {
                            Starships.configure()
                        }
                        self.entityPicker.reloadAllComponents()
                        self.updateUI()
                    }
                } else {
                    print("Error in retrieveStarWarsPage is: \(error)")     ///Create an alert here??
                }
            }
        }
    }
    
    func fetchCharacterHomeworld(for character: Character, withPeopleIndex index: Int) {
        
        //Ensure character detail is available:
        guard var detail = character.detail else { return }
        
        var character = character
        
        client.getStarWarsData(from: detail.homeworldURL, toType: Planet.self) { [unowned self] planetDetail, error in
            if let planetDetail = planetDetail {
                detail.home = planetDetail.name
                //Write back to the allEntities static array
                character.detail = detail
                People.allEntities[index] = character
                if let viewModel = CharacterViewModel(from: character, with: self.measureType) {
                    self.setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            } else {
                print("Error: Network call didn't work:\(error)")
            }
        }
    }
    
    //Fetch entity values based on entity picked
    func setFieldValues(for pickerRowNumber: Int) {
        
        guard let entities = self.allEntities else { return }
        
        
        switch entities {
        case .characters:
            var character = People.allEntities[pickerRowNumber]
            //Check to see if the character detail is missing
            if character.detail == nil {
                client.getStarWarsData(from: character.url, toType: CharacterDetail.self) { [unowned self] characterDetail, error in
                    if let characterDetail = characterDetail {
                        character.detail = characterDetail
                        //Fetch homeworld name:
                        print("Fetching homeworld name")
                        self.fetchCharacterHomeworld(for: character, withPeopleIndex: pickerRowNumber)
                    } else {
                        print("Network call didn't work:\(error)")
                    }
                }
            } else {    //Data exists - simply load
                print("Data already exists for \(character.name) - no need for network call")
                if let viewModel = CharacterViewModel(from: character, with: self.measureType) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }
            
            
        case .vehicles:
            var vehicle = Vehicles.allEntities[pickerRowNumber]
            //Check to see if the vehicle detail is missing
            if vehicle.detail == nil {
                client.getStarWarsData(from: vehicle.url, toType: VehicleDetail.self) { [unowned self] vehicleDetail, error in
                    if let vehicleDetail = vehicleDetail {
                        //Assign to the network call results to the vehicle’s detail property
                        vehicle.detail = vehicleDetail
                        //Write back to the allEntities static array
                        Vehicles.allEntities[pickerRowNumber] = vehicle
                        if let viewModel = VehicleViewModel(from: vehicle, with: self.measureType) {
                            self.setFieldValues(using: viewModel)
                        } else {
                            print("Error: Could not create view model")
                        }
                    } else {
                        print("Network call didn't work:\(error)")
                    }
                }
            } else {    //Data exists - simply load
                print("Data already exists for \(vehicle.name) - no need for network call")
                if let viewModel = VehicleViewModel(from: vehicle, with: self.measureType) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }
            
        case .starships:
            var starship = Starships.allEntities[pickerRowNumber]
            //Check to see if the starship detail is missing
            if starship.detail == nil {
                client.getStarWarsData(from: starship.url, toType: StarshipDetail.self) { [unowned self] starshipDetail, error in
                    if let starshipDetail = starshipDetail {
                        //Assign to the network call results to the starship’s detail property
                        starship.detail = starshipDetail
                        //Write back to the allEntities static array
                        Starships.allEntities[pickerRowNumber] = starship
                        if let viewModel = StarshipViewModel(from: starship, with: self.measureType) {
                            self.setFieldValues(using: viewModel)
                        } else {
                            print("Error: Could not create view model")
                        }
                    } else {
                        print("Network call didn't work:\(error)")
                    }
                }
            } else {    //Data exists - simply load
                print("Data already exists for \(starship.name) - no need for network call")
                if let viewModel = StarshipViewModel(from: starship, with: self.measureType) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }
        }
    }


}

//MARK: - Helper Methods - UI
extension EntityDetailController {
    
    func updateUI(){
        
        guard let entities = self.allEntities else { return }
        
        //Set the shortest/tallest buttons
        switch entities {
            case .characters:
            if let minimumHeightCharacterIndex = People.minimumHeightCharacterIndex, let maximumHeightCharacterIndex = People.maximumHeightCharacterIndex {
                shortestButton.setTitle(People.allEntities[minimumHeightCharacterIndex].name, for: .normal)
                longestButton.setTitle(People.allEntities[maximumHeightCharacterIndex].name, for: .normal)
            }
            case .vehicles:
            if let minimumLengthCraftIndex = Vehicles.minimumLengthCraftIndex, let maximumLengthCraftIndex = Vehicles.maximumLengthCraftIndex {
                shortestButton.setTitle(Vehicles.allEntities[minimumLengthCraftIndex].name, for: .normal)
                longestButton.setTitle(Vehicles.allEntities[maximumLengthCraftIndex].name, for: .normal)
            }
            case .starships:
            if let minimumLengthCraftIndex = Starships.minimumLengthCraftIndex, let maximumLengthCraftIndex = Starships.maximumLengthCraftIndex {
                shortestButton.setTitle(Starships.allEntities[minimumLengthCraftIndex].name, for: .normal)
                longestButton.setTitle(Starships.allEntities[maximumLengthCraftIndex].name, for: .normal)
            }
        }
        
        //Set field values for the picker default row
        setFieldValues(for: 0)
    }
    
    func setFieldLabels() {
        
        guard let entities = self.allEntities else { return }
        
        switch entities {
        case .characters:
            mainRowLabels?[0].text = "Born"
            mainRowLabels?[1].text = "Home"
            mainRowLabels?[2].text = "Height"
            mainRowLabels?[3].text = "Eyes"
            mainRowLabels?[4].text = "Hair"
            longestLabel.text = "Tallest"
            pilotsLabel.isHidden = false
            
        case .vehicles, .starships:
            mainRowLabels?[0].text = "Make"
            mainRowLabels?[1].text = "Cost"
            mainRowLabels?[2].text = " Length"
            mainRowLabels?[3].text = "Class"
            mainRowLabels?[4].text = "Crew"
            longestLabel.text = "Longest"
            pilotsLabel.isHidden = true
            pilotsCell.accessoryType = .none
        }
    }
    
    func showFields(setTo: Bool) {
        
        headerLabel.isHidden = !setTo
        
        for field in mainRowFields {
            field.isHidden = !setTo
        }
    }
    
    func showLengthButtons(setTo: Bool) {
        
        shortestButton.isHidden = !setTo
        longestButton.isHidden = !setTo
    }
    
    func setFieldValues(using viewModel: EntityViewModel) {
        headerLabel.text = viewModel.name
        mainRowFields[0].text = viewModel.row1
        mainRowFields[1].text = viewModel.row2
        mainRowFields[2].text = viewModel.row3
        mainRowFields[3].text = viewModel.row4
        mainRowFields[4].text = viewModel.row5
        
        //Check for piloted craft & turn on accessibility indicator if present
        if let characterViewModel = viewModel as? CharacterViewModel {
            if characterViewModel.hasPilotedCraft {
                pilotsCell.accessoryType = .disclosureIndicator
                pilotsCell.isUserInteractionEnabled = true
                pilotsLabel.alpha = 1.0
            } else {
                pilotsCell.accessoryType = .none
                pilotsCell.isUserInteractionEnabled = false
                pilotsLabel.alpha = 0.5
            }
        }
        
        showFields(setTo: true)
    }

    func initializeUI() {
        
        //entityPicker Height Calculation
        let tableHeight = (tableView.bounds.height)
        
        let window = UIApplication.shared.keyWindow
        if let topPadding = window?.safeAreaInsets.top, let bottomPadding = window?.safeAreaInsets.bottom {
            entityPickerRowHeightCalculation = tableHeight - topPadding - bottomPadding - 510.0 - 40.0      //510 is sum of other row heights, 40 padding.
        }
        
        //Nav Bar title & back bar formatting:
        if let entity = self.allEntities {
            let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            let attributes: [NSAttributedString.Key: Any] = [  .font: font,
                                                               .foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = attributes
            self.title = entity.titleForNavigationBar()
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        //Font size formatting - to fit label or field:
        headerLabel.adjustsFontSizeToFitWidth = true
        mainRowFields[0].adjustsFontSizeToFitWidth = true
        
        //Button Formatting:
        shortestButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shortestButton.layer.borderWidth = 1
        shortestButton.layer.borderColor = UIColor.darkGray.cgColor
        longestButton.titleLabel?.adjustsFontSizeToFitWidth = true
        longestButton.layer.borderWidth = 1
        longestButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func conversionUpdate() {
        
        guard let entityType = self.allEntities else { return }
        
        switch entityType {
        case .characters:
            let character = People.allEntities[entityPicker.selectedRow(inComponent: 0)]
            if let viewModel = CharacterViewModel(from: character, with: self.measureType) {
                setFieldValues(using: viewModel)
            }
        case .vehicles:
            let vehicle = Vehicles.allEntities[entityPicker.selectedRow(inComponent: 0)]
            if let viewModel = VehicleViewModel(from: vehicle, with: self.measureType) {
                setFieldValues(using: viewModel)
            }
        case .starships:
            let starship = Starships.allEntities[entityPicker.selectedRow(inComponent: 0)]
            if let viewModel = StarshipViewModel(from: starship, with: self.measureType) {
                setFieldValues(using: viewModel)
            }
        }
    }
    
}

//MARK: - Segues
extension EntityDetailController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("In should perform segue")
        //Only segue from Character & with correct identifier
        if identifier == "pilotedVehicles" && self.allEntities == .characters {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Get the destination view controller - only if the right type
        guard let pilotedCraftController = segue.destination as? PilotedCraftController else {
            print("Error:  Attempted segue not registered")
            return
        }
        
        pilotedCraftController.character = People.allEntities[entityPicker.selectedRow(inComponent: 0)]
        pilotedCraftController.pickerIndex = entityPicker.selectedRow(inComponent: 0)
    }
}

