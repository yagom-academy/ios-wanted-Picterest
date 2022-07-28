//
//  NetworkAPI.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

struct NetworkAPI {
    
    static let schema = "https"
    static let host = "api.unsplash.com"
    
    func getRandomImageAPI(page: Int) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = NetworkAPI.schema
        components.host = NetworkAPI.host
        components.path = "/photos"
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "XEWW_uPfwublfP0Vds0M6MP1JCcgSJniF9q38N8FyL4"),
            URLQueryItem(name: "count", value: "15"),
            URLQueryItem(name: "page", value: String(page))
        ]
        return components
    }
}

