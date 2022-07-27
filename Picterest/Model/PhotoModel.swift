//
//  PhotoModel.swift
//  Picterest
//
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: Urls
}

struct Urls: Codable {
    let raw: String
    let regular: String
}
