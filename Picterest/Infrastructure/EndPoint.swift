//
//  EndPoint.swift
//  WeatherInfo
//
//  Created by 이다훈 on 2022/06/09.
//

import Foundation

struct EndPoint {
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    private let scheme: String
    private let host: String
    private let path: String
    private let method: HTTPMethod
    private let queryItems: [URLQueryItem]?
    
    init(scheme: String,
         host: String,
         apiPath: String,
         httpMethod: HTTPMethod,
         items: [URLQueryItem]? = nil) {
        
        self.scheme = scheme
        self.host = host
        self.path = apiPath
        self.method = httpMethod
        self.queryItems = items
    }
    
    func asUrlRequest() throws -> URLRequest {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = queryItems
        guard let url = component.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = self.method.rawValue
        
        return request
    }
}
