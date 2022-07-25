//
//  NetworkManager.swift
//  Picterest
//
//  Created by oyat on 2022/07/25.
//

import Foundation

class NetworkManager {
    
    typealias Response = Int
    
    // MARK: - Properties
    static let shard = NetworkManager()
    private let api = NetworkAPI()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchImages(completion: @escaping (Result<[ImageInfo], CustomError>) -> ()) {
        
        guard let url = api.imagesAPI().url else {
            completion(.failure(CustomError.makeURLError))
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.loadError))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.noData))
                }
                return
            }
            
            do {
                let hasData = try JSONDecoder().decode([ImageInfo].self, from: data)
                    completion(.success(hasData))
            } catch {
                    completion(.failure(CustomError.decodingError))
            }
        }.resume()
    }
}
