//
//  ListViewModelTests.swift
//  Finding FalconeTests
//
//  Created by Tushar on 10/09/23.
//

import XCTest
@testable import Finding_Falcone

class ListViewModelTests: XCTestCase {

    var viewModel: ListViewModel!

    override func setUp() {
        super.setUp()
        let mockPlanets = [Planet(name: "Planet1", distance: 100), Planet(name: "Planet2", distance: 200)]
        let mockVehicles = [Vehicle(name: "Vehicle1", count: 1, speed: 50, range: 100), Vehicle(name: "Vehicle2", count: 1, speed: 75, range: 200)]
        viewModel = ListViewModel(planetsData: mockPlanets, vehicleData: mockVehicles)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test updateSelectedVehicleCount() method
    func testUpdateSelectedVehicleCount() {
        viewModel.updateSelectedVehicleCount("Vehicle1", increment: true)
        XCTAssertEqual(viewModel.currentVehicleCount.first(where: { $0.name == "Vehicle1" })?.count, 2)
    }

    // Test calculateSearchTime() method
    func testCalculateSearchTime() {
        viewModel.selectedPlanets = [nil, nil, nil, nil]
        viewModel.selectedVehicles = [nil, nil, nil, nil]
        viewModel.selectedPlanets[0] = Planet(name: "Planet3", distance: 300)
        viewModel.selectedVehicles[0] = Vehicle(name: "Vehicle1", count: 1, speed: 50, range: 100)
        XCTAssertEqual(viewModel.calculateSearchTime(), 6)
    }
    
    // Test resetAll() method
    func testResetAll() {
        viewModel.selectedPlanets[0] = Planet(name: "Planet3", distance: 300)
        viewModel.selectedVehicles[0] = Vehicle(name: "Vehicle1", count: 1, speed: 50, range: 100)
        viewModel.receivedToken = "mockToken"
        viewModel.findFalconResult = FindFalconeResponse(status: "success", planet_name: "Planet1", error: nil)

        viewModel.resetAll()

        XCTAssertEqual(viewModel.selectedPlanets.filter { $0 != nil }.count, 0)
        XCTAssertEqual(viewModel.selectedVehicles.filter { $0 != nil }.count, 0)
        XCTAssertNil(viewModel.receivedToken)
        XCTAssertNil(viewModel.findFalconResult)
        XCTAssertEqual(viewModel.currentVehicleCount.count, 2)
    }
    
}

