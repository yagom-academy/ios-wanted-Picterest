//
//  ImageLoader.swift
//  Picterest
//
//  Created by yc on 2022/07/26.
//

import UIKit

enum ImageLoaderError: String, Error {
    case invalidURL
    case invalidRequest
    case serverError
    case unknown
    
    var description: String { rawValue }
}

final class ImageLoader {
    static let shared = ImageLoader()
    
    private init() {}
    
    func downloadImage(
        urlString: String,
        completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void
    ) {
        if let cachedImage = CacheManager.shared.object(forKey: urlString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(.unknown))
                return
            }
            
            CacheManager.shared.setObject(image, forKey: urlString as NSString)
            completion(.success(image))
        }.resume()
    }
}
