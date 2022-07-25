//
//  NetworkAPI.swift
//  Picterest
//
//  Created by oyat on 2022/07/25.
//

import Foundation

struct NetworkAPI {
    
    // MARK: - Properties
    let clientIdKey = Bundle.main.clientIdKey
    static let schema = "https"
    static let host = "api.unsplash.com"
    
    
    func imagesAPI() -> URLComponents {
        var components = URLComponents()
        components.scheme = NetworkAPI.schema
        components.host = NetworkAPI.host
        components.path = "/photos/random"
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientIdKey),
            URLQueryItem(name: "count", value: "15"),
            URLQueryItem(name: "per_page", value: "15")
            
        ]
        return components
    }
    
}
