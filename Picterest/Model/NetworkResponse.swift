//
//  NetworkResponse.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

protocol AAA {}

struct Photo: Codable, AAA {
    let id: String
    let width: Int
    let height: Int
    let urls: UrlInfo
    
    struct UrlInfo: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}
