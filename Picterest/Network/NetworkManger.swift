//
//  NetworkManger.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let api = NetworkAPI()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getImageInfo(page: Int, completion: @escaping (Result<[ImageInfo], CustomError>) -> ()) {
        
        guard let url = api.getRandomImageAPI(page: page).url else {
            completion(.failure(CustomError.makeURLError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.error(error: error)))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(CustomError.responseError(code:httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(CustomError.noData))
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
