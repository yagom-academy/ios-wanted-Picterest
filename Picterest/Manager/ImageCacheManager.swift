//
//  ImageCacheManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
}
