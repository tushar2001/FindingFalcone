//
//  HomeViewModelTests.swift
//  Finding FalconeTests
//
//  Created by Tushar on 10/09/23.
//

import Foundation
import XCTest
@testable import Finding_Falcone

final class HomeViewModelTests: XCTestCase {
    
    func testFetchData() {
        // Created expectation for the API call
        let planetExpectation = expectation(description: "Planet data fetched")
        let vehicleExpectation = expectation(description: "Vehicle data fetched")
        
        let viewModel = HomeViewModel()
        viewModel.fetchData()
        
        // Wait for the planet data API call to complete
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Check if planetData is not nil
            XCTAssertNotNil(viewModel.planetData)
            planetExpectation.fulfill()
            
        }
        
        // Wait for the vehicle data API call to complete
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Check if vehicleData is not nil
            XCTAssertNotNil(viewModel.vehicleData)
            vehicleExpectation.fulfill()
        }
        
        // Wait for both expectations to be fulfilled
        wait(for: [planetExpectation, vehicleExpectation], timeout: 3)
    }
}
