//
//  NetworkHelper.swift
//  Finding Falcone
//
//  Created by Tushar on 10/09/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidRequest
    case decodingFailed(Error)
}

struct NetworkHelper {
    
    static func fetchData<T: Decodable>(
        from url: URL,
        responseType: T.Type,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(responseType, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
    
    static func postRequest<T: Decodable>(
        to url: URL,
        body: Data?,
        responseType: T.Type,
        headers: [String: String],
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(responseType, from: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
}
