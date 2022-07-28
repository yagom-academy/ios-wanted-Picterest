//
//  PhotoListEndPoint.swift
//  Picterest
//
//  Created by BH on 2022/07/25.
//

import Foundation

class PhotoListEndPoint: EndPointType {
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        return "/photos"
    }
    
    var query: [URLQueryItem] {
        return [URLQueryItem(name: "client_id", value: apiKey),
                URLQueryItem(name: "per_page", value: "15"),
                URLQueryItem(name: "page", value: "\(page)")
        ]
    }
    
    var apiKey: String {
        return Bundle.main.apiKey
    }
    
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
}
