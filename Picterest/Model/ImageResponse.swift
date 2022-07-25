//
//  ImageResponse.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation

struct Image: Codable {
    let id: String
    let width: Double
    let height: Double
    let urls: ImageURL
}

struct ImageURL: Codable {
    let small: String
}
