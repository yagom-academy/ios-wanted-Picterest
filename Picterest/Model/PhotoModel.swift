//
//  PhotoModel.swift
//  Picterest
//
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let width: Double
    let height: Double
    let urls: Urls
}

struct Urls: Codable {
    let raw: String
    let regular: String
    let small: String
}
