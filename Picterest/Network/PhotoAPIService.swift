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
    
    func getRandomPhoto(_ page: Int, _ completion: @escaping (Result<[Photo], APIError>) -> Void) {
        var request = URLRequest(url: EndPoint.getPhoto(page).url)
        
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
                let userData = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(userData))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}
