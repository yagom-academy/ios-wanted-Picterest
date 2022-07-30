//
//  File.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import UIKit

class ImageCacheManager {
   
   static let shared = NSCache<NSString, UIImage>()
   
   private init() {}
}
