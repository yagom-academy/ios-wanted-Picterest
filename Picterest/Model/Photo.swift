//
//  Photo.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

struct Photo: Codable {
    let id: String
    let urls: [Urls]
}

struct Urls: Codable {
    let full: String
}
