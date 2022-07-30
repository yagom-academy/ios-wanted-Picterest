//
//  APIEndPoints.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation
struct APIEndpoints {
    static func getPhotosInfo(with photoInfoRequestDTO: PhotoInfoRequestDTO) -> EndPoint<[PhotoInfoResponseDTO]> {
        return EndPoint(baseURL: "https://api.unsplash.com/",
                        path: "photos",
                        method: .get,
                        queryParameters: photoInfoRequestDTO,
                        headers: ["Authorization": "Client-ID \(Constants.accessKey)"])
    }
}


