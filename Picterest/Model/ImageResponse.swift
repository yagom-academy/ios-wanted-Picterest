//
//  ImageResponse.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation

struct Image: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: ImageURL
}

struct ImageURL: Codable {
    let raw: String
}
