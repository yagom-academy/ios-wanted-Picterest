//
//  Network.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/28.
//

import UIKit

enum NetWorkError: Error {
    case unknown
}

protocol NetWorkAble {
    var task: URLSessionDataTask? { get }
    func configureURL() -> URL?
    func requestNetwork(completion: @escaping (Result<Data, NetWorkError>) -> Void)
}

class ImageLoader: NetWorkAble {
    var task: URLSessionDataTask?
    private var endPoint: EndPoint
    
    init(endPoint: EndPoint) {
        self.endPoint = endPoint
    }
    
    func configureURL() -> URL? {
        guard var components = URLComponents(string: endPoint.baseURL) else {
            return nil
        }
        
        components.queryItems = endPoint.query?.configureQuerys()
        guard let url = components.url else {
            return nil
        }
        return url
    }
    func requestNetwork(completion: @escaping (Result<Data, NetWorkError>) -> Void) {
        if let imageLoadURL = configureURL() {
            task = URLSession.shared.dataTask(with: imageLoadURL) { data, response, error in
                guard error == nil else {
                    completion(.failure(.unknown))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(.unknown))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.unknown))
                    return
                }
                completion(.success(data))
            }
            
            task?.resume()
        }
    }
    
    func cancelTask() {
        task?.cancel()
        task = nil
    }
}

class ImageDataLoader: NetWorkAble {
    var task: URLSessionDataTask?
    private var pageNumber: Int = 1
    private var endPoint: EndPoint
    
    init(endPoint: EndPoint) {
        self.endPoint = endPoint
    }
    
    func configureURL() -> URL? {
        guard var components = URLComponents(string: endPoint.baseURL) else {
            return nil
        }
        if let apiKey = endPoint.apiKey {
            let query: [String: String] = [
                "client_id": apiKey,
                "page": pageNumber.description,
                "per_page": "15"
            ]
            components.queryItems = query.configureQuerys()
        }
        
        guard let url = components.url else {
            return nil
        }
        return url
    }
    
    func requestNetwork(completion: @escaping (Result<Data, NetWorkError>) -> Void) {
        
        if let imageDataLoadURL = configureURL() {
            task = URLSession.shared.dataTask(with: imageDataLoadURL) { data, response, error in
                guard error == nil else {
                    print("Error in data add")
                    completion(.failure(.unknown))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(.unknown))
                    print("Error in status code")
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.unknown))
                    return
                }
                self.pageNumber += 1
                completion(.success(data))
            }
            task?.resume()
        }
    }
    
}
