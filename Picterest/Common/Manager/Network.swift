//
//  Network.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

enum NetworkError: String, Error {
    case invalidRequest
    case jsonError
    case serverError
    case unknown
    
    var description: String { rawValue }
}

final class Network {
    private let page: Int
    private let clientID = "jGA9GAwx92PWFeD_ptnML18QqLz5M3zpjGVEqXIKw7g"
    private let perPage = 15
    private let path = "https://api.unsplash.com/photos"
    
    init(page: Int) {
        self.page = page
    }
    
    func fetch(completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        var urlComponent = URLComponents(string: path)
        urlComponent?.setQueryItems(with: [
            "client_id": clientID,
            "page": "\(page)",
            "per_page": "\(perPage)"
        ])
        
        guard let url = urlComponent?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else  {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
}
