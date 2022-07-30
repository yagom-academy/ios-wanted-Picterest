//
//  UIImageView+Custom.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import UIKit

extension UIImageView {
    func load(urlString: String) -> UIImage {
        let cachedImage = ImageCacheManager.shared.cachedImage(urlString: urlString)
        if cachedImage != nil {
            self.image = cachedImage
            return UIImage()
        }
        
        guard let url = URL(string: urlString) else { return UIImage() }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            ImageCacheManager.shared.setObject(image: image, urlString: urlString)
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
        return image ?? UIImage()
    }
}
