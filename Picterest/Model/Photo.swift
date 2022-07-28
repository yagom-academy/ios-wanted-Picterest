//
//  Photo.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let width: Double
    let height: Double
    let urls: Urls
}

struct Urls: Decodable {
    let small: String
    let full: String
}
