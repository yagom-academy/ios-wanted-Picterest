//
//  PhotoAPIService.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

enum APIError: Error {
    case unexpectedStatusCode(statusCode: String)
    case invalidResponse
    case noData
    case failed
    case invalidData
}

class PhotoAPIService {
    
    private let accessKey = "RlALhP2d1f-1NTL_O2Y4t0RdHBvEgwgrrYRMxsF963Q"
    
    func getRandomPhoto(_ completion: @escaping (Result<Photo, APIError>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=\(accessKey)") else {
            completion(.failure(.failed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.failed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(.unexpectedStatusCode(statusCode: "\(response.statusCode)")))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(Photo.self, from: data)
                completion(.success(userData))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}
