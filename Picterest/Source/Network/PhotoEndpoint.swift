//
//  PhotoEndpoint.swift
//  Picterest
//
//  Created by 이윤주 on 2022/07/29.
//

import Alamofire
import Foundation

enum PhotoEndpoint: EndPointType {
    
    case getPhoto
    
    var baseURL: String {
        return "https://api.unsplash.com"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPhoto:
            return .get
        }
    }
    
    var apiKey: String {
        switch self {
        case .getPhoto:
            return "yVGmATwgQ50f6Q_zGJc5t_uhhweNqORAN4if0wo2NQg"
        }
        
    }
    
    var path: String {
        switch self {
        case .getPhoto:
            return "/photos/random"
        }
    }
    
}
