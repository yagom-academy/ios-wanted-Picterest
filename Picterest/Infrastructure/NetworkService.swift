//
//  NetworkService.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Foundation
import Combine

protocol NetworkService {
    func getPhotos(howMuch count: Int) throws -> AnyPublisher<[PhotoDTO],Error>
}

class DefaultNetworkService: NetworkService {
    
    private let networkRequester: NetworkRequester
    
    init(networkRequester: NetworkRequester = DefaultNetworkRequester()) {
        self.networkRequester = networkRequester
    }
    
    func getPhotos(howMuch count: Int) throws -> AnyPublisher<[PhotoDTO],Error> {
        guard let request = try? APIEndPoint.init()
            .getPhotosEndPoint(howMuchPicture: 2)
            .asUrlRequest() else {
            throw URLError(.badURL)
        }
        
        return networkRequester.request(with: request)
    }
    
}
