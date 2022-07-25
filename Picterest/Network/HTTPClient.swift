//
//  HTTPClient.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/26.
//

import Foundation

class HTTPClient {
    func getRandomPhoto<T: Decodable>(endpoint: URLRequest, completion: @escaping(Result<[T], APIError>) -> Void) {
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: endpoint) { data, response, error in
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
                let userData = try decoder.decode([T].self, from: data)
                completion(.success(userData))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
