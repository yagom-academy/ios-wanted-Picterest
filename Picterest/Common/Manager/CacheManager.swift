//
//  CacheManager.swift
//  Picterest
//
//  Created by yc on 2022/07/26.
//

import UIKit

class CacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
