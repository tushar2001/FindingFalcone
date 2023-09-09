//
//  FalconModel.swift
//  Finding Falcone
//
//  Created by Tushar on 06/09/23.
//
import Foundation

protocol CustomCopyable {
    func copy() -> Self
}

// struct to represent a planet and its distance from Lengaburu
struct Planet: Codable, Hashable {
    let name: String
    let distance: Int
}

// struct to represent a vehicle and its properties
struct Vehicle: Codable, Hashable, Equatable, CustomCopyable {
    let name: String
    var count: Int
    let speed: Int
    let range: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case count = "total_no"
        case range = "max_distance"
        case speed = "speed"
    }
    
    func copy() -> Vehicle {
        return Vehicle(name: self.name, count: self.count, speed: self.speed, range: self.range)
    }
}

// Struct to represent the result of the search
struct FindFalconeResponse: Codable {
    let status: String
    let planet_name: String?
    let error: String?
}

struct Token: Codable {
    let token: String
}

// Extend Array to perform a deep copy
extension Array where Element: CustomCopyable {
    func deepCopy() -> [Element] {
        return self.map { $0.copy() }
    }
}
