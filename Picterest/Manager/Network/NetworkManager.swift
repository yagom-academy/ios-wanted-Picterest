//
//  NetworkManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation
import Combine
import UIKit

enum NetworkError: Error {
    case failCreateRequest
    case invalidStatusCode(statusCode: Int)
}

final class NetworkManager {
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchRandomImageInfo<T>(resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.urlRequest else {
            return Fail(error: NetworkError.failCreateRequest)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse,
                      (200..<300) ~= response.statusCode else {
                    let response = response as? HTTPURLResponse
                    throw NetworkError.invalidStatusCode(statusCode: response?.statusCode ?? -1)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func fetchImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let image = ImageCacheManager.shared.getImage(urlString) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            ImageCacheManager.shared.storeImage(urlString, image: image)
            completion(image)
        }.resume()
    }
}
