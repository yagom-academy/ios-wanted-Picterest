//
//  EndPoint.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/30.
//

import Foundation

struct EndPoint {
    var baseURL: String
    var query: [String: String]?
    var apiKey: String?
    
    var queryItems: [URLQueryItem] {
        guard let query = query else {
            return []
        }

        return query.configureQuerys()
    }
}
