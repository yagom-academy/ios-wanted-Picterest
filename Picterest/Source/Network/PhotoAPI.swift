//
//  PhotoAPI.swift
//  Picterest
//
//  Created by 이윤주 on 2022/07/29.
//

import Alamofire
import Foundation

enum PhotoAPIError: LocalizedError {
    
    case invalidPhotoData
    
    var errorDescription: String? {
        switch self {
        case .invalidPhotoData:
            return "사진을 불러오는 데 실패했습니다."
        }
    }
}

final class PhotoAPI {
    
    private let networkRequester = NetworkRequester()
    private var photoDownloadTask: URLSessionDataTask?
    private var imageCache = NSCache<NSString, UIImage>()

    func fetchImageURL(
        completion: @escaping (Result<[PhotoResponse], Error>) -> Void
    ) {
        networkRequester.request(to: PhotoEndpoint.getPhoto) { result in
            switch result {
            case .success(let data):
                guard let decoded = try? JSONDecoder().decode([PhotoResponse].self, from: data)
                else { return }
                completion(.success(decoded))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        if let task = photoDownloadTask {
            task.cancel()
        }
        
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(.success(cachedImage))
            return
        }
        
        photoDownloadTask = networkRequester.request(to: urlString) { [weak self] result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {
                    completion(.failure(PhotoAPIError.invalidPhotoData))
                    return
                }
                self?.imageCache.setObject(image, forKey: cacheKey)
                completion(.success(image))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
        photoDownloadTask?.resume()
    }

}
