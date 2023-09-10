//
//  ListViewModel.swift
//  Finding Falcone
//
//  Created by Tushar on 06/09/23.
//

import Foundation

class ListViewModel {
    
    var planets: [Planet]
    var vehicles: [Vehicle]
    
    var currentVehicleCount: [Vehicle]
    var receivedToken: String?
    var findFalconResult: FindFalconeResponse?
    
    var selectedPlanets: [Planet?] = [nil, nil, nil, nil]
    var selectedVehicles: [Vehicle?] = [nil, nil, nil, nil]
    
    init(planetsData: [Planet], vehicleData: [Vehicle]) {
        self.planets = planetsData
        self.vehicles = vehicleData
        currentVehicleCount = vehicles.deepCopy()
    }
    
    // check if 4 planets are selected
    func isSearchReady() -> Bool {
        return selectedPlanets.compactMap{ $0 }.count == 4 && selectedVehicles.compactMap{ $0 }.count == 4
    }
    
    func updateSelectedVehicleCount(_ vehicleName: String, increment: Bool) {
        for index in 0..<currentVehicleCount.count {
            if currentVehicleCount[index].name == vehicleName {
                if increment {
                    currentVehicleCount[index].count += 1
                } else {
                    currentVehicleCount[index].count -= 1
                }
                break
            }
        }
    }
    
    // Method to calculate the estimated search time based on selected planets and vehicles
    func calculateSearchTime() -> Int {
        var time: Int = 0
        for (index, planet) in selectedPlanets.enumerated() {
            var distance = 0
            var speed: Int
            if let planet = planet {
                distance = planet.distance
                if let vehicle = selectedVehicles[index] {
                    speed = vehicle.speed
                    time += distance/speed
                }
                else { time += 0 }
            }
            else { time += 0 }
        }
        return time
    }
    
    func searchFalcone(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.updateToken{ [weak self] success in
                guard let weakself = self else { return }
                if success {
                    Api.findFalcone(token: weakself.receivedToken ?? "",
                                    planetNames: weakself.selectedPlanets.map { $0!.name },
                                    vehicleNames: weakself.selectedVehicles.map { $0!.name }) { result in
                        switch result {
                        case .success(let response):
                            print("Status: \(response.status)")
                            if let planetName = response.planet_name {
                                print("Found Falcone on planet: \(planetName)")
                            } else if let error = response.error {
                                print("Error: \(error)")
                            }
                            weakself.findFalconResult = response
                            completion(true)
                        case .failure(let error):
                            print("Error: \(error)")
                            completion(false)
                        }
                    }
                }
                else {
                    completion(false)
                }
            }
        }
    }
    
    func updateToken(completion: @escaping (Bool) -> Void) {
        Api.getToken { result in
            switch result {
            case .success(let token):
                self.receivedToken = token.token
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }

}

extension ListViewModel {
    func resetAll() {
        selectedPlanets = [nil, nil, nil, nil]
        selectedVehicles = [nil, nil, nil, nil]
        receivedToken = nil
        findFalconResult = nil
        currentVehicleCount = vehicles.deepCopy()
    }
}
