//
//  EntityDetailController.swift
//  TheAPIAwakens_revC
//
//  Created by Gavin Butler on 28-09-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class EntityDetailController: UITableViewController {
    
    var allEntities: AllEntities?                           //Type of entities being displayed - People, Vehicles, or Starships
    let client = StarWarsAPIClient()                        //Networking
    var entityPickerRowHeightCalculation: CGFloat = 0.0     //Picker is set to remaining height after allowing for all other cells & views.
    var measureType: MeasureType = .metric {                //Metric/Imperial
        didSet {
            conversionUpdate()
        }
    }
    var currencyType: Currency = .credits {                 //USD/Credits
        didSet {
            conversionUpdate()
        }
    }

    //Outlet variables
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet var mainRowLabels: [UILabel]!             //Starts from the 'Born' label
    @IBOutlet var mainRowFields: [UILabel]!             //Starts from the 'Born' field.
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    @IBOutlet weak var pilotsCell: UITableViewCell!
    @IBOutlet weak var pilotsLabel: UILabel!
    
    @IBOutlet weak var exchangeRateTextField: UITextField!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
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
        
        //Customize labels, buttons etc in accordance with selected entities being displayed.
        setFieldLabels()
        
        //Perform network fetch if required, otherwize just load from existing array.
        fetchEntities(entitiesToLoad: entitiesToLoad)
        
    }
    
    //Retrieve shortest entity index from the static datasource,
    //Automate picker selection based on shortest button press - then display the corresponding data.
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
    
    //Retrieve longest entity index from the static datasource,
    //Automate picker selection based on shortest button press - then display the corresponding data.
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
    
    //Set the measure type, control button behaviour.
    @IBAction func imperialButtonPressed(_ sender: UIButton) {
        measureType = .imperial
        imperialButton.setTitleColor(.lightGray, for: .normal)
        metricButton.setTitleColor(.white, for: .normal)
        imperialButton.isUserInteractionEnabled = false
        metricButton.isUserInteractionEnabled = true
    }
    
    //Set the measure type, control button behaviour.
    @IBAction func metricButtonPressed(_ sender: Any) {
        measureType = .metric
        metricButton.setTitleColor(.lightGray, for: .normal)
        imperialButton.setTitleColor(.white, for: .normal)
        imperialButton.isUserInteractionEnabled = true
        metricButton.isUserInteractionEnabled = false
    }
    
    //Set the currency type, control button/textfield behaviour.
    @IBAction func usdButtonPressed(_ sender: UIButton) {
        currencyType = .usd     //Triggers Model update with conversion and UI refresh
        usdButton.setTitleColor(.lightGray, for: .normal)
        creditsButton.setTitleColor(.white, for: .normal)
        usdButton.isUserInteractionEnabled = false
        creditsButton.isUserInteractionEnabled = true
        exchangeRateTextField.isHidden = false
        exchangeRateLabel.isHidden = false
    }
    
    //Set the currency type, control button/textfield behaviour.
    @IBAction func creditButtonPressed(_ sender: UIButton) {
        
        //Check for valid entry on text field
        guard validRateEntered() else { return }
        
        //Remove the keyboard if it was up (exchange no longer appplies)
        exchangeRateTextField.resignFirstResponder()
        
        exchangeRateTextField.isHidden = true
        exchangeRateLabel.isHidden = true
        currencyType = .credits     //Triggers Model update with conversion and UI refresh
        usdButton.setTitleColor(.white, for: .normal)
        creditsButton.setTitleColor(.lightGray, for: .normal)
        usdButton.isUserInteractionEnabled = true
        creditsButton.isUserInteractionEnabled = false
        
        
    }

}


//MARK:- Tableview delegation

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
        case 1: return entityPickerRowHeightCalculation         //Entity Picker received residual height
        case 2: return 100.0                                    //Footer view containing shortest/longest buttons
        default: return 45                                      //Top Data rows
        }
    }
    
    
}


//MARK:- Pickerview delegation & data source

extension EntityDetailController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Return the number of items in the static datasource for the associated entity
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let entities = self.allEntities else { return 0 }
        
        switch entities {
        case .characters:   return People.allEntities.count
        case .vehicles:     return Vehicles.allEntities.count
        case .starships:    return Starships.allEntities.count
        }
    }
    
    //Return entity name to be displayed in the picker.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let entities = self.allEntities else { return "" }
        
        switch entities {
        case .characters:   return People.allEntities[row].name
        case .vehicles:     return Vehicles.allEntities[row].name
        case .starships:    return Starships.allEntities[row].name
        }
        
    }
    
    //Pass the row as index to the allEntities static datasource.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setFieldValues(for: row)
    }
}

//MARK: - Helper Methods - Networking
extension EntityDetailController {
    
    //Deterimine if the list of all entities has already been fetched.  If so, just reload the picker.
    //If not, execute the network call.
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
    
    //Execute the network call to retrieve all entities.  Cycle through pages until no further pages are found.
    //Load datasource static array as pages of entities are fetched.
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
                    } else {        //Final page and allEntity static arrays are loaded.  Get back on the main thread.
                        //Sort the entities by name & determine longest & shortest using the configure method.
                        DispatchQueue.main.async {
                            if let _ = entities as? People {
                                People.configure()
                            }
                            else if let _ = entities as? Vehicles {
                                Vehicles.configure()
                            } else if let _ = entities as? Starships {
                                Starships.configure()
                            }
                            //Reload the picker & update the fields.
                            self.entityPicker.reloadAllComponents()
                            self.updateUI()
                        }
                    }
                } else {
                    print("Error: in retrieveStarWarsPage is: \(String(describing: error))")
                }
            }
        }
    }
    
    //Performed after retrieving the main detail for the character (which contains the homeworld URL), and before updating the UI.
    func fetchCharacterHomeworld(for character: Character, withPeopleIndex index: Int) {
        
        //Ensure character detail is available:
        guard var detail = character.detail else { return }
        
        var character = character
        
        client.getStarWarsData(from: detail.homeworldURL, toType: EntityName.self) { [unowned self] planetDetail, error in
            if let planetDetail = planetDetail {
                //Get back on the main thread.
                DispatchQueue.main.async {
                    detail.home = planetDetail.name
                    //Write back to the allEntities static array
                    character.detail = detail
                    People.allEntities[index] = character
                    //Regenerate the view model and display
                    if let viewModel = CharacterViewModel(from: character, with: self.measureType) {
                        self.setFieldValues(using: viewModel)
                    } else {
                        print("Error: Could not create view model")
                    }
                }
            } else {
                print("Error: Fetch results could not be cast to type:\(String(describing: error))")
            }
        }
    }
    
    //Fetch single entity values based on entity picked.  Populate entity 'detail' variable with the results.
    func setFieldValues(for pickerRowNumber: Int) {
        
        guard let entities = self.allEntities else { return }
        
        switch entities {
        case .characters:
            //Get the picked character from the datasource
            var character = People.allEntities[pickerRowNumber]
            //Check to see if the character detail is missing
            if character.detail == nil {
                client.getStarWarsData(from: character.url, toType: CharacterDetail.self) { [unowned self] characterDetail, error in
                    //Get back on the main thread.
                    DispatchQueue.main.async {
                        if let characterDetail = characterDetail {
                            character.detail = characterDetail
                            //Fetch homeworld name & update UI
                            self.fetchCharacterHomeworld(for: character, withPeopleIndex: pickerRowNumber)
                        } else {
                            print("Error: Fetch results could not be cast to type:\(String(describing: error))")
                        }
                    }
                }
            } else {    //Data exists - simply load
                if let viewModel = CharacterViewModel(from: character, with: self.measureType) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }
            
            
        case .vehicles:
            //Get the picked vehicle from the datasource
            var vehicle = Vehicles.allEntities[pickerRowNumber]
            //Check to see if the vehicle detail is missing
            if vehicle.detail == nil {
                client.getStarWarsData(from: vehicle.url, toType: VehicleDetail.self) { [unowned self] vehicleDetail, error in
                    if let vehicleDetail = vehicleDetail {
                        //Get back on the main thread.
                        DispatchQueue.main.async {
                            //Assign to the network call results to the vehicle’s detail property
                            vehicle.detail = vehicleDetail
                            //Write back to the allEntities static array
                            Vehicles.allEntities[pickerRowNumber] = vehicle
                            //Create the view model with reference to the selected measure type and currency.
                            if let viewModel = VehicleViewModel(from: vehicle, with: self.measureType, in: self.currencyType) {
                                self.setFieldValues(using: viewModel)
                            } else {
                                print("Error: Could not create view model")
                            }
                        }
                    } else {
                        print("Error: Fetch results could not be cast to type:\(String(describing: error))")
                    }
                }
            } else {    //Data exists - simply load
                if let viewModel = VehicleViewModel(from: vehicle, with: self.measureType, in: self.currencyType) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }
            
        case .starships:
            //Get the picked starship from the datasource
            var starship = Starships.allEntities[pickerRowNumber]
            //Check to see if the starship detail is missing
            if starship.detail == nil {
                client.getStarWarsData(from: starship.url, toType: StarshipDetail.self) { [unowned self] starshipDetail, error in
                    //Get back on the main thread.
                    DispatchQueue.main.async {
                        if let starshipDetail = starshipDetail {
                            //Assign to the network call results to the starship’s detail property
                            starship.detail = starshipDetail
                            //Write back to the allEntities static array
                            Starships.allEntities[pickerRowNumber] = starship
                            //Create the view model with reference to the selected measure type and currency.
                            if let viewModel = StarshipViewModel(from: starship, with: self.measureType, in: self.currencyType) {
                                self.setFieldValues(using: viewModel)
                            } else {
                                print("Error: Could not create view model")
                            }
                        } else {
                            print("Error: Fetch results could not be cast to type:\(String(describing: error))")
                        }
                    }
                }
            } else {    //Data exists - simply load
                print("Data already exists for \(starship.name) - no need for network call")
                if let viewModel = StarshipViewModel(from: starship, with: self.measureType, in: self.currencyType) {
                    setFieldValues(using: viewModel)
                } else {
                    print("Error: Could not create view model")
                }
            }
        }
    }


}

//MARK: - Helper Methods - UI
extension EntityDetailController: UITextFieldDelegate {
    
    //Display shortest/Longest entities and display the values for first entity in the picker.
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
        
        //Expose the shortest/tallest buttons
        shortestButton.isHidden = false
        longestButton.isHidden = false
    }
    
    //Configure the tableview controller fields to reflect the type of entity choses in the start screen
    //Also configure button visibility to suit.
    func setFieldLabels() {
        
        guard let entities = self.allEntities else { return }
        
        switch entities {
        case .characters:
            mainRowLabels?[0].text = "Born"
            mainRowLabels?[1].text = "Home"
            mainRowLabels?[2].text = "Height"
            mainRowLabels?[3].text = "Eyes"
            mainRowLabels?[4].text = "Hair"
            usdButton.isHidden = true
            creditsButton.isHidden = true
            longestLabel.text = "Tallest"
            pilotsLabel.text = "Pilots:"
            exchangeRateLabel.isHidden = true
            exchangeRateTextField.isHidden = true
            
            
        case .vehicles, .starships:
            mainRowLabels?[0].text = "Make"
            mainRowLabels?[1].text = "Cost"
            mainRowLabels?[2].text = " Length"
            mainRowLabels?[3].text = "Class"
            mainRowLabels?[4].text = "Crew"
            usdButton.isHidden = false
            creditsButton.isHidden = false
            longestLabel.text = "Longest"
            pilotsLabel.text = "Forex:"
            pilotsCell.accessoryType = .none
        }
    }
    
    //Populate the fields from the view model
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
        } else {     //Dealing with a vehicle or starship
            exchangeRateTextField.text = CurrencyExchange.usdDescription()
        }
        
        showFields(setTo: true)
    }
    
    //Helper method to expose or hide fields as required.
    func showFields(setTo: Bool) {
        
        guard let entities = self.allEntities else { return }
        
        headerLabel.isHidden = !setTo
        
        for field in mainRowFields {
            field.isHidden = !setTo
        }
        
        if entities != .characters && currencyType == .usd {
            exchangeRateLabel.isHidden = false
            exchangeRateTextField.isHidden = false
        }

    }

    func initializeUI() {
        
        //Button Formatting:
        shortestButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shortestButton.layer.borderWidth = 1
        shortestButton.layer.borderColor = UIColor.darkGray.cgColor
        shortestButton.isHidden = true
        longestButton.titleLabel?.adjustsFontSizeToFitWidth = true
        longestButton.layer.borderWidth = 1
        longestButton.layer.borderColor = UIColor.darkGray.cgColor
        longestButton.isHidden = true
        
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
        
        //Remove the default 'Back' title from the Navigation Bar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        
        //Font size formatting - to fit label or field:
        headerLabel.adjustsFontSizeToFitWidth = true
        mainRowFields[0].adjustsFontSizeToFitWidth = true
        mainRowFields[3].adjustsFontSizeToFitWidth = true
        
        //Configure delegates and functions for keyboard interactions
        configureExchangeRateTextField()
    }
    
    func configureExchangeRateTextField () {
        //To set this class as the delegate and receive event calls
        exchangeRateTextField.delegate = self
        
        //Keyboard observers:  Might not need these
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(EntityDetailController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.whenTapped(gestureRecognizer:)))
        tableView.addGestureRecognizer(tap)
        //entityPicker.addGestureRecognizer(tap)
    }
    
    @objc func whenTapped(gestureRecognizer: UIGestureRecognizer) {
        guard validRateEntered() else { return }
        
        // Remove the gesture recognizer:
        tableView.removeGestureRecognizer(gestureRecognizer)
        //Close the decimal pad
        exchangeRateTextField.resignFirstResponder()
        
        //Write the new value & update UI
        if let rateText = exchangeRateTextField.text, let rate = Double(rateText) {
            CurrencyExchange.setCurrency(to: rate)
            conversionUpdate()
        }
    }
    
    func validRateEntered() -> Bool {
        //Check that the field is not empty or has more than 2 decimals
        guard exchangeRateTextField.text != "" && exchangeRateTextField.text != "." else {
            simpleAlertWithMessage("Text field must contain digits")
            return false
        }
        let count = exchangeRateTextField.text?.filter { $0 == "." }.count ?? 0
        guard count <= 1 else {
            simpleAlertWithMessage("Only 1 decimal point permitted")
            return false
        }
        return true
    }
    
    func simpleAlertWithMessage(_ message: String) {
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "Invalid Exchange Rate", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


    
    //Regenerate view model and display with reference to new measure and/or currency settings
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
            if let viewModel = VehicleViewModel(from: vehicle, with: self.measureType, in: self.currencyType) {
                setFieldValues(using: viewModel)
            }
        case .starships:
            let starship = Starships.allEntities[entityPicker.selectedRow(inComponent: 0)]
            if let viewModel = StarshipViewModel(from: starship, with: self.measureType, in: self.currencyType) {
                setFieldValues(using: viewModel)
            }
        }
    }
    
}

//MARK: - Segues
extension EntityDetailController {
    
    //Only segue from Character & with correct identifier
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
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
        
        //Set the selected character on the PilotedCraft Controller to allow piloted craft detail to be retried & displayed.
        pilotedCraftController.character = People.allEntities[entityPicker.selectedRow(inComponent: 0)]
    }
}

