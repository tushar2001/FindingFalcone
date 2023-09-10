//
//  ViewController.swift
//  Finding Falcone
//
//  Created by Tushar Tayal on 06/09/23.
//

import UIKit

// MARK:  Struct to associate PickerView with TextField
struct PickerTextField {
    var picker: UIPickerView
    var textfield: UITextField
}

class ListViewController: UIViewController {
    
    private var indexPickerTextFieldMap: [Int: PickerTextField] = [:]
    
    private let planetPickersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Taken: 0 hours"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        configurePlanetPickers()
    }
    
    // MARK: Set up the UI elements and their constraints
    private func setupUI() {
        view.addSubview(planetPickersStackView)
        view.addSubview(searchButton)
        view.addSubview(timeLabel)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            
            resetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            
            planetPickersStackView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 8),
            planetPickersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            planetPickersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            planetPickersStackView.bottomAnchor.constraint(greaterThanOrEqualTo: timeLabel.topAnchor, constant: 10),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: 20),
            
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 50), // Adjust as needed
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: Configure the planet pickers
    private func configurePlanetPickers() {
        for (index) in 0..<4 {
            let titleLabel = createTitleLabel(forIndex: index)
            let planetPicker = createPlanetPicker(forIndex: index)
            let vehiclePicker = createVehiclePicker(forIndex: index)
            planetPickersStackView.addArrangedSubview(titleLabel)
            planetPickersStackView.addArrangedSubview(planetPicker)
            planetPickersStackView.addArrangedSubview(vehiclePicker)
        }
    }
    
    // MARK: Create label to represent Destination index
    private func createTitleLabel(forIndex: Int) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = "Destination \(forIndex + 1)"
        titleLabel.sizeToFit()
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .darkText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }
    
    // MARK: Create textField and picker for planet picker
    private func createPlanetPicker(forIndex: Int) -> UITextField {
        let textField = UITextField()
        let picker = UIPickerView()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Select Planet"
        textField.inputView = picker
        
        picker.dataSource = self
        picker.delegate = self
        
        textField.tag = forIndex
        picker.tag = forIndex
        picker.accessibilityIdentifier = "Planet Picker"
        
        indexPickerTextFieldMap[forIndex] = PickerTextField(picker: picker, textfield: textField)
        
        return textField
    }
    
    // MARK: Create textField and picker for vehicle picker
    private func createVehiclePicker(forIndex: Int) -> UITextField {
        let textField = UITextField()
        let picker = UIPickerView()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Select Vehicle"
        textField.isEnabled = false
        textField.inputView = picker
        
        picker.dataSource = self
        picker.delegate = self
        
        textField.tag = forIndex + 10
        picker.tag = forIndex + 10
        picker.accessibilityIdentifier = "Vehicle Picker"
        
        textField.addTarget(self, action:#selector(vehicleTextFieldTap), for: .editingDidBegin)
        
        indexPickerTextFieldMap[forIndex + 10] = PickerTextField(picker: picker, textfield: textField)
        
        return textField
    }
    
    // MARK: Handle tap confiuration of vehicle textfield
    @objc private func vehicleTextFieldTap(sender: UITextField) {
        let textField = sender
        
        let alert = UIAlertController(title: "Vehicle Information", message: "All Vehicle ranges are less than planet distance. Please change the planet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        let selectedPlanetIndex = textField.tag - 10
        let selectedPlanet = viewModel.selectedPlanets[selectedPlanetIndex]!
        
        // Filter available vehicles by range and count eligibility
        let eligibleVehicles = viewModel.currentVehicleCount.filter { vehicle in
            return vehicle.range >= selectedPlanet.distance && vehicle.count > 0
        }
        
        if eligibleVehicles.count == 0 {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
     // MARK: Handle tap configuration of search button
    @objc private func searchButtonTapped(_ sender: UIButton) {
        if viewModel.isSearchReady() {
            updateSearchTime()
            viewModel.searchFalcone { [weak self] success in
                guard let weakself = self else { return }
                if success {
                    let resultViewModel = ResultViewModel(result: weakself.viewModel.findFalconResult ?? FindFalconeResponse(status: "", planet_name: "", error: ""))
                    resultViewModel.delegate = self
                    DispatchQueue.main.async { [weak self] in
                        let resultController = ResultViewController(viewModel: resultViewModel)
                        self?.navigationController?.pushViewController(resultController, animated: true)
                    }
                }
                else {
                    // MARK: Alert if token or search call fails
                    let alert = UIAlertController(title: "Error", message: "Failed to search Falcone.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    weakself.present(alert, animated: true)
                }
            }
        } else {
            // MARK: Alert if all 4 planets are not selected
            let alert = UIAlertController(title: "Select 4 planets to search", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: Handle tap configuration of reset button
    @objc private func resetButtonTapped(_ sender: UIButton) {
        resetAll()
    }
}

extension ListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Row count for vehicle picker
        if pickerView.tag >= 10 {
            let selectedPlanetIndex = pickerView.tag - 10
            let selectedPlanet = viewModel.selectedPlanets[selectedPlanetIndex]!
            
            // Filter eligible vehicles by range and count eligibility
            let eligibleVehicles = viewModel.currentVehicleCount.filter { vehicle in
                return vehicle.range >= selectedPlanet.distance && vehicle.count > 0
            }
            
            return eligibleVehicles.count
        }
        // Row count for planet picker
        else {
            let selectedPlanets = viewModel.selectedPlanets.compactMap { $0 }
            let availablePlanets = viewModel.planets.filter { !selectedPlanets.contains($0) }
            return availablePlanets.count
        }
    }
}

extension ListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Title for Row for vehicle picker
        if pickerView.tag >= 10 {
            let selectedPlanetIndex = pickerView.tag - 10
            let selectedPlanet = viewModel.selectedPlanets[selectedPlanetIndex]!
            
            // Filter eligible vehicles by range and count eligibility
            let eligibleVehicles = viewModel.currentVehicleCount.filter { vehicle in
                return vehicle.range >= selectedPlanet.distance && vehicle.count > 0
            }
            
            return "\(eligibleVehicles[row].name) (\(eligibleVehicles[row].count))"
        }
        // Title for row for planet picker
        else {
            let selectedPlanets = viewModel.selectedPlanets.compactMap { $0 }
            let availablePlanets = viewModel.planets.filter { !selectedPlanets.contains($0) }
            return availablePlanets[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // For vehicle picker
        if pickerView.tag >= 10 {
            handleVehiclePickerSelection(pickerView, row: row)
        }
        // For planet picker
        else {
            handlePlanetPickerSelection(pickerView, row: row)
        }
        dismissKeyboard(forPicker: pickerView)
    }
    
    private func handlePlanetPickerSelection(_ pickerView: UIPickerView, row: Int) {
        let selectedPlanets = viewModel.selectedPlanets.compactMap { $0 }
        let availablePlanets = viewModel.planets.filter { !selectedPlanets.contains($0) }
        
        let selectedPlanet = availablePlanets[row]
        let pickerIndex = pickerView.tag
        viewModel.selectedPlanets[pickerIndex] = selectedPlanet
        updateTextField(forPicker: pickerView, withValue: selectedPlanet.name)
        
        enableAssociatedVehicleTextField(pickerView)
    }

    private func handleVehiclePickerSelection(_ pickerView: UIPickerView, row: Int) {
        let selectedPlanetIndex = pickerView.tag - 10
        guard let selectedPlanet = viewModel.selectedPlanets[selectedPlanetIndex] else {
            return
        }
        
        let eligibleVehicles = viewModel.currentVehicleCount.filter { vehicle in
            return vehicle.range >= selectedPlanet.distance && vehicle.count > 0
        }
        
        if let selectedVehicle = viewModel.selectedVehicles[selectedPlanetIndex] {
            viewModel.updateSelectedVehicleCount(selectedVehicle.name, increment: true)
        }
        
        viewModel.updateSelectedVehicleCount(eligibleVehicles[row].name, increment: false)
        
        let newSelectedVehicle = eligibleVehicles[row]
        viewModel.selectedVehicles[selectedPlanetIndex] = newSelectedVehicle
        updateTextField(forPicker: pickerView, withValue: newSelectedVehicle.name)
        updateSearchTime()
    }
    
    private func updateTextField(forPicker pickerView: UIPickerView, withValue value: String) {
        if let textField = indexPickerTextFieldMap[pickerView.tag]?.textfield {
            textField.text = value
        }
    }
    
    private func enableAssociatedVehicleTextField(_ pickerView: UIPickerView) {
        if let vehicleTextField = indexPickerTextFieldMap[pickerView.tag + 10]?.textfield {
            vehicleTextField.isEnabled = true
        }
    }
    
    private func dismissKeyboard(forPicker pickerView: UIPickerView) {
        if let textField = indexPickerTextFieldMap[pickerView.tag]?.textfield {
            textField.resignFirstResponder()
        }
    }
    
    private func updateSearchTime() {
        let estimatedTime = viewModel.calculateSearchTime()
        timeLabel.text = "Estimated Time: \(estimatedTime) hours"
    }
}

extension ListViewController: StartOverDelegate {
    func resetAll() {
        viewModel.resetAll()
        for field in indexPickerTextFieldMap.values {
            let textfield = field.textfield
            textfield.text = ""
            if textfield.tag >= 10 {
                textfield.isEnabled = false
            }
        }
        timeLabel.text = "Time Taken: 0 hours"
    }
}
