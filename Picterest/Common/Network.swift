//
//  Network.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

enum NetworkError: Error {
    case unkown
}

class Network {
    static let shard = Network()
    private init() {}
    private let clientID = "7EoAQCEONksYSL9jv2U0iSUGUzpTffG6_YrGTdTXF2o"
    private let count = 15
    private let path = "https://api.unsplash.com/photos/random"
    
    func get(completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        var urlComponent = URLComponents(string: path)
        urlComponent?.setQueryItems(with: [
            "client_id": clientID,
            "count": "\(count)"
        ])
        
        guard let url = urlComponent?.url else {
            completion(.failure(.unkown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unkown))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else  {
                completion(.failure(.unkown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unkown))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(.unkown))
            }
        }.resume()
    }
}
