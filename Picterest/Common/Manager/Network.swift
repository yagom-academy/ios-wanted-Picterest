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
    private let page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    private let clientID = "jGA9GAwx92PWFeD_ptnML18QqLz5M3zpjGVEqXIKw7g"
    private let perPage = 15
    private let path = "https://api.unsplash.com/photos"
    
    func get(completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        var urlComponent = URLComponents(string: path)
        urlComponent?.setQueryItems(with: [
            "client_id": clientID,
            "page": "\(page)",
            "per_page": "\(perPage)"
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
