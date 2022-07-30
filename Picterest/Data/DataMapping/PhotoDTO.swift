//
//  PhotoDTO.swift
//  Picterest
//
//  Created by 이다훈 on 2022/07/29.
//

import Foundation

struct PhotoDTO: Codable {
    let id: String
    let width: Double
    let height: Double
    let urls: PhotoURLs
}

struct PhotoURLs: Codable {
    let small: String
    let regular: String
}
