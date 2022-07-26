//
//  CacheManager.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/26.
//

import UIKit

class CacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
