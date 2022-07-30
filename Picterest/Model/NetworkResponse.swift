//
//  NetworkResponse.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

protocol Photable {}

struct Photo: Decodable, Photable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLInfo
    
    struct URLInfo: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}
