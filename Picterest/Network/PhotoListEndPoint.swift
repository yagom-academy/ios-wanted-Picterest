//
//  PhotoListEndPoint.swift
//  Picterest
//
//  Created by BH on 2022/07/25.
//

import Foundation

enum PhotoListEndPoint: EndPointType {
    
    case getPhotoList
    
    var apiKey: String {
        return Bundle.main.apiKey
    }
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        return "/photos"
    }
    
    var query: [URLQueryItem] {
        return [URLQueryItem(name: "client_id", value: apiKey)]
    }
    
}
