//
//  EndPoint.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

enum EndPoint {
    case getPhoto(Int)
}

extension EndPoint {
    static let accessKey = "RlALhP2d1f-1NTL_O2Y4t0RdHBvEgwgrrYRMxsF963Q"
    static let per_page = 15
    
    var url: URL {
        switch self {
        case .getPhoto(let page):
            return .makeEndPoint("?client_id=\(EndPoint.accessKey)&per_page=\(EndPoint.per_page)&page=\(page)")
        }
    }
}

extension URL {
    static let baseURL = "https://api.unsplash.com/photos/"
    
    static func makeEndPoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}

