//
//  Resource.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation

struct Resource<T: Codable> {
    
    // MARK: - Properties
    private var base: String
    private var path: String
    private var params: [String: String]
    private var header: [String: String]
    
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: base + path) else { return nil }
        let queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        header.forEach {
            request.addValue($0.key, forHTTPHeaderField: $0.value)
        }
        
        return request
    }
    
    // MARK: - LifeCycle
    init(
        base: String = "https://api.unsplash.com",
        path: String = "/photos",
        params: [String: String],
        header: [String: String] = ["Client-ID \(APIKey.accessKey)": "Authorization"]
    ) {
        self.base = base
        self.path = path
        self.params = params
        self.header = header
    }
}
