//
//  NetworkRequester.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Combine
import Foundation

enum NetworkRequesterErrors: Error {
    case badURLResponseError
    case badURLRequestResponseError
}

protocol NetworkRequester {
    func request<T: Codable> (with request: URLRequest) -> AnyPublisher<T, Error>
    func request (with url: URL) -> AnyPublisher<Data, Error>
}

class DefaultNetworkRequester: NetworkRequester {
    
    func request<T: Codable> (with request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({
                guard let httpResponse = $0.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkRequesterErrors.badURLRequestResponseError
                }
                
                return $0.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func request (with url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({
                guard let httpResponse = $0.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkRequesterErrors.badURLResponseError
                }
                
                return $0.data
            })
            .eraseToAnyPublisher()
    }
    
}

