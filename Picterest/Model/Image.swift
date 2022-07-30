//
//  Image.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

struct ImageData {
    let image: Image
    var memo: String
    var isSaved: Bool
    
    init(image: Image, memo: String, isSaved: Bool) {
        self.image = image
        self.memo = memo
        self.isSaved = isSaved
    }
}

struct Image: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLs
}

struct URLs: Decodable {
    let small: String
}
