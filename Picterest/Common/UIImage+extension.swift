//
//  UIImage+extension.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import UIKit

extension UIImageView {
    func setImageUrl(_ url: String) -> Bool {
        var isChached = false
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.sync {
                    isChached = true
                    self.image = cachedImage
                }
                return
            }

            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                        self?.image = image
                    }
                }
            }.resume()
        }
        return isChached
    }
}
