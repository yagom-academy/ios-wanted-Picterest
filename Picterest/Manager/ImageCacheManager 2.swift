//
//  ImageCacheManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation
import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func storeImage(_ url: String, image: UIImage) {
        cache.setObject(image, forKey: url as NSString)
    }
    
    func getImage(_ url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
}
