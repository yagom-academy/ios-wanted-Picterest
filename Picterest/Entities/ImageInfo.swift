//
//  Images.swift
//  Picterest
//
//  Created by oyat on 2022/07/25.
//

import Foundation

struct ImageInfo: Codable {
    let id: String
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    var raw, full, regular, small: String
    var thumb : String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}
