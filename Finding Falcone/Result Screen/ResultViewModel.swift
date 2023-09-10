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
    
    // A property to store the result of the search
    var result: FindFalconeResponse
    var delegate: StartOverDelegate?
    
    init(result: FindFalconeResponse) {
        self.result = result
    }
    
    // A function to reset the data and start over
    func startOver() {
        delegate?.resetAll()
    }
}
