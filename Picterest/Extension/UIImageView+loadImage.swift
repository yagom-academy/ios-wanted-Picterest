//
//  UIImageView+loadImage.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

extension UIImageView {
    
    func loadImage(_ urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        
        var task: URLSessionDataTask?
        let imageCacheManager = ImageCacheManager.shared
        
        let key = urlString as NSString
        
        if let task = task {
            task.cancel()
        }
        
        if let cachedData = imageCacheManager.load(key) {
            image = UIImage(data: cachedData)
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            imageCacheManager.save(key, data)

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
        task?.resume()
    }
}
