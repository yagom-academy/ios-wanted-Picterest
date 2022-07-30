//
//  ImageLoader.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/26.
//
import UIKit

private enum ImageLoaderError: Error {
    case noImage
    case invalidImageURL
}

final class ImageLoder {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    func leadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if url.isEmpty {
            completion(.failure(ImageLoaderError.invalidImageURL))
        }
        if let image = ImageLoder.imageCache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                completion(.success(image))
            }
            return
        }
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: url) else { return }
            let session = URLSession(configuration: .ephemeral)
            let task = session.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    completion(.failure(NetworkError.requestFail(error)))
                }
                guard let httpResponse = response as? HTTPURLResponse else { return }
                guard 200..<300 ~= httpResponse.statusCode else { completion(.failure(NetworkError.failedResponse(statusCode: httpResponse.statusCode)))
                    return
                }
                if let data = data {
                    guard let image = UIImage(data: data) else { return }
                    ImageLoder.imageCache.setObject(image, forKey: url as NSString)
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.emptyData))
                    }
                }
            }
            task.resume()
        }
    }
}
