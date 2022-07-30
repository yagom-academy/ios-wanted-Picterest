//
//  ImageLoader.swift
//  Picterest
//
//

import UIKit

enum ImageLoaderError: Error {
    case invalidImageURL
    case noResponseError
    case inavalidImageData
}

final class ImageLoder {
    static let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = ImageLoder.imageCache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                completion(.success(image))
            }
            return
        }
        guard let imageUrl = URL(string: url) else { return print(ImageLoaderError.invalidImageURL)}
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard 200..<300 ~= (response as? HTTPURLResponse)?.statusCode ?? -1 else {
                    completion(.failure(ImageLoaderError.noResponseError))
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
                        completion(.failure(ImageLoaderError.inavalidImageData))
                    }
                }
            }
            task.resume()
    }
}
