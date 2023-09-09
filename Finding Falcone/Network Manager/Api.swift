//
//  Api.swift
//  Finding Falcone
//
//  Created by Tushar on 10/09/23.
//

import Foundation

class Api {
    
    static func fetchPlanetData(completionHandler: @escaping ([Planet]) -> Void) {
        guard let url = URL(string: "https://findfalcone.geektrust.com/planets") else {
            return
        }
        NetworkHelper.fetchData(from: url, responseType: [Planet].self) { result in
            switch result {
            case .success(let planets):
                print(planets)
                completionHandler(planets)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchVehicleData(completionHandler: @escaping ([Vehicle]) -> Void) {
        guard let url = URL(string: "https://findfalcone.geektrust.com/vehicles") else {
            return
        }
        NetworkHelper.fetchData(from: url, responseType: [Vehicle].self) { result in
            switch result {
            case .success(let vehicles):
                print(vehicles)
                completionHandler(vehicles)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getToken(completion: @escaping (Result<Token, Error>) -> Void) {
        guard let url = URL(string: "https://findfalcone.geektrust.com/token") else {
            print(NetworkError.invalidURL)
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let headers = ["Accept" : "application/json"]
        
        NetworkHelper.postRequest(to: url, body: nil, responseType: Token.self, headers: headers) { result in
            switch result {
            case .success(let token):
                print(token.token)
                completion(.success(token))
            case .failure(let error):
                print(error)
                completion(.failure(error))
                
            }
        }
    }
    
    static func findFalcone(token: String,
                            planetNames: [String],
                            vehicleNames: [String],
                            completion: @escaping (Result<FindFalconeResponse, Error>) -> Void) {
        
        guard let url = URL(string: "https://findfalcone.geektrust.com/find") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let headers = ["Accept" : "application/json",
                       "Content-Type" : "application/json"]
        
        let requestBody: [String: Any] = [
            "token": token,
            "planet_names": planetNames,
            "vehicle_names": vehicleNames
        ]
        
        // Serialize the request body into JSON data
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        NetworkHelper.postRequest(to: url, body: requestBodyData, responseType: FindFalconeResponse.self, headers: headers) { result in
            switch result {
            case .success(let falconResponse):
                completion(.success(falconResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
