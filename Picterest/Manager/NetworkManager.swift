//
//  NetworkManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case networkingError
    case decodingError
    case serverError
    case unknownError
}

final class NetworkManager {
    
    let apiKey = "EYcGnmZWJmPQPhb1Hw9nXqv7mo7p_Vr4XpVnkkMqN5I"
    
    static let shared = NetworkManager()
    
    func fetchImageList(completion: @escaping (Result<[Image], NetworkError>) -> Void) {
        let urlStr = "https://api.unsplash.com/photos/random/?client_id=\(apiKey)&count=15"
        guard let url = URL(string: urlStr) else {
            completion(.failure(.invalidURL))
            return
        }
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkingError))
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            switch response.statusCode {
            case 200...299:
                let decorder = JSONDecoder()
                guard let data = try? decorder.decode([Image].self, from: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(data))
            default:
                print("Error - StatusCode: \(response.statusCode), Response: \(response)")
            }
        }.resume()
    }
}
