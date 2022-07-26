//
//  PhotoModel.swift
//  Picterest
//
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let urls: Urls
    let links: Links
}

struct Urls: Codable {
    let raw: String
    let regular: String
}

struct Links: Codable {
    let download: String
}
