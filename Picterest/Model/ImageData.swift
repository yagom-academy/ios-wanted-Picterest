//
//  PhotoModel.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation

struct ImageData: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLsModel
}

struct URLsModel: Decodable {
    let small: String
}
