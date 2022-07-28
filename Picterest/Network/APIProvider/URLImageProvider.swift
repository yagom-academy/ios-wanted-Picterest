//
//  URLImageProvider.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import UIKit

protocol URLImageProviderType {
    
    func fetchImage(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void)
    
}

class URLImageProvider: URLImageProviderType {
    
    private let networkRequester: NetworkRequesterType
    private var URLImageTask: URLSessionDataTask?
    private let imageCache = NSCache<NSString, UIImage>()
    
    init(networkRequester: NetworkRequesterType) {
        self.networkRequester = networkRequester
    }
    
    func fetchImage(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(.success(cachedImage))
            return
        }
        
        URLImageTask = networkRequester.request(to: urlString, completion: { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.setObject(image, forKey: cacheKey)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

