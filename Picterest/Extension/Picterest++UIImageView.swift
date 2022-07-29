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
            
        NetworkManager.shared.fetchImage(url: url) { image in
            ImageCacheManager.shared.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func loadFromLocal(id: String) {
        let documentURL = LocalFileManager.shared.documentURL
        guard let imageURL = documentURL?.appendingPathComponent(id) else { return }
        if FileManager.default.fileExists(atPath: imageURL.path) {
            guard let image = UIImage(contentsOfFile: imageURL.path) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
