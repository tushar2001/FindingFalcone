//
//  HomeViewModel.swift
//  Finding Falcone
//
//  Created by OLX on 09/09/23.
//

import Foundation

class HomeViewModel {
    
    var planetData: [Planet]?
    var vehicleData: [Vehicle]?
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        Api.fetchPlanetData { [weak self] planets in
            guard let weakSelf = self else { return }
            weakSelf.planetData = planets
        }
        
        Api.fetchVehicleData { [weak self] vehicles in
            guard let weakSelf = self else { return }
            weakSelf.vehicleData = vehicles
        }
    }
}
