//
//  Image.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

struct Image: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLs
}

struct URLs: Decodable {
    let small: String
}
