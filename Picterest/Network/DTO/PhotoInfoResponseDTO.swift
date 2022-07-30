//
//  PhotoInfoDTO.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/25.
//

import Foundation

struct PhotoInfoResponseDTO: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: Urls
    let links: Links
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smalls3: String
    
    enum CodingKeys: String, CodingKey {
        case smalls3 = "small_s3"
        case raw, full, regular, small,thumb
    }
}

struct Links: Codable {
    let unsplash: String
    let html: String
    let download: String
    let downloadLocation: String
    
    enum CodingKeys: String, CodingKey {
        case unsplash = "self"
        case downloadLocation = "download_location"
        case html, download
    }
}

extension PhotoInfoResponseDTO {
    func toDomain() -> PhotoInfo {
        return PhotoInfo(id: id, width: width, height: height, urls: urls, links: links, isSaved: false)
    }
}
