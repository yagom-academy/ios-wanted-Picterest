//
//  APIEndPoint.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Foundation

struct APIEndPoint {
    enum SchemeType: String {
        case http = "http"
        case https = "https"
    }
    
    enum ApiPath: String {
        case photos = "/photos"
    }
    
    enum HostType: String {
        case api = "api.unsplash.com"
    }
    
    init() {}
    
    private let apiKeyQueryItem: URLQueryItem = .init(name: "client_id", value: APIKey.init().accessKey)
    
    
    func getPhotosEndPoint(howMuchPicture count: Int) -> EndPoint {
        
        let picturePerPageQueryItem: URLQueryItem = .init(name: "per_page", value: "\(count)")
        
        return EndPoint.init(scheme: SchemeType.https.rawValue,
                             host: HostType.api.rawValue,
                             apiPath: ApiPath.photos.rawValue,
                             httpMethod: .get,
                             items: [apiKeyQueryItem,
                                     picturePerPageQueryItem]
        )
    }
    
}
