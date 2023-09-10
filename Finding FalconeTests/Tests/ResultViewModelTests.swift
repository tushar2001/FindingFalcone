//
//  ResultViewModelTests.swift
//  Finding FalconeTests
//
//  Created by Tushar on 10/09/23.
//

import XCTest
@testable import Finding_Falcone

// Mock StartOverDelegate
class MockStartOverDelegate: StartOverDelegate {
    var resetAllCalled = false

    func resetAll() {
        resetAllCalled = true
    }
}

class ResultViewModelTests: XCTestCase {

    var viewModel: ResultViewModel!

    override func setUp() {
        super.setUp()
        // Mock of FindFalconeResponse
        let mockResponse = FindFalconeResponse(status: "success", planet_name: "Earth", error: nil)
        viewModel = ResultViewModel(result: mockResponse)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test startOver
    func testStartOver() {
        // Mock delegate instance
        let mockDelegate = MockStartOverDelegate()
        viewModel.delegate = mockDelegate

        viewModel.startOver()

        // Assert true if resetAll method of mock delegate was called
        XCTAssertTrue(mockDelegate.resetAllCalled)
    }
}
