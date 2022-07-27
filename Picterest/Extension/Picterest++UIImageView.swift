//
//  Picterest++UIImageView.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

extension UIImageView {
    
    func loadImage(url: String) {
        let key = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: key) {
            self.image = cachedImage
            print("from cache")
            return
        }
            
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let fetchedData = data, let image = UIImage(data: fetchedData), error == nil else { return }
            ImageCacheManager.shared.setObject(image, forKey: key)
            DispatchQueue.main.async {
                self?.image = image
            }
            print("from download")
        }.resume()
    }
}
