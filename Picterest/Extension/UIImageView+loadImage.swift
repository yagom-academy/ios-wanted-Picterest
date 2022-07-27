//
//  UIImageView+loadImage.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

extension UIImageView {
    
    func loadImage(urlString: String?, imageID: String) {
        guard let urlString = urlString else {
            return
        }
        
        let imageCacheManager = ImageCacheManager.shared
        let imageFileManager = ImageFileManager.shared
        var task: URLSessionDataTask?
        let key = imageID as NSString
        
        if let task = task {
            task.cancel()
        }
        
        if let cachedData = imageCacheManager.load(key) {
            image = UIImage(data: cachedData)
            print("Cache have image data of \(key)")
            return
        }
        
        if imageFileManager.fileExists(key), let savedData = imageFileManager.load(key) {
            image = UIImage(data: savedData)
            imageCacheManager.save(key, savedData)
            print("Device have image data of \(key)")
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
