//
//  ImageInformation.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation

struct ImageInformation: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: ImageURL
}

struct ImageURL: Decodable {
    let small: String
}
