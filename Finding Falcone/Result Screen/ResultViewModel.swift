//
//  ResultViewModel.swift
//  Finding Falcone
//
//  Created by Tushar on 09/09/23.
//

import Foundation

protocol StartOverDelegate: AnyObject {
    func resetAll()
}

class ResultViewModel {
    
    // Property to store the result of search
    var result: FindFalconeResponse
    var delegate: StartOverDelegate?
    
    init(result: FindFalconeResponse) {
        self.result = result
    }
    
    // To reset the data on start over click
    func startOver() {
        delegate?.resetAll()
    }
}
