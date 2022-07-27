//
//  Image.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

struct Image: Decodable {
    let id: String
    let urls: URLs
}

struct URLs: Decodable {
    let thumb: String
}
