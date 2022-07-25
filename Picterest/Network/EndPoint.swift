//
//  EndPoint.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

enum EndPoint {
    case getPhoto
}

extension EndPoint {
    static let accessKey = "RlALhP2d1f-1NTL_O2Y4t0RdHBvEgwgrrYRMxsF963Q"
    static let count = 15
    
    var url: URL {
        switch self {
        case .getPhoto:
            return .makeEndPoint("random/?client_id=\(EndPoint.accessKey)&count=\(EndPoint.count)")
        }
    }
}

extension URL {
    static let baseURL = "https://api.unsplash.com/photos/"
    
    static func makeEndPoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}

