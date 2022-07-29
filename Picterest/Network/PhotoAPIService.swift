//
//  PhotoAPIService.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

enum APIError: Error {
    case unexpectedStatusCode(statusCode: String)
    case invalidResponse
    case noData
    case failed
    case invalidData
}

class PhotoAPIService {
    
    func getPhoto(_ page: Int, _ completion: @escaping (Result<[Photo], APIError>) -> Void) {
        let request = URLRequest(url: EndPoint.getPhoto(page).url)
        URLSession.request(endpoint: request, completion: completion)
    }
}
