//
//  RandomImage.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation

struct RandomImageEntity: Codable {
    let id: String
    let urls: RandomImageURL
    let width: Double
    let height: Double
    
    var imageRatio: Double {
        return height / width
    }
}

struct RandomImageURL: Codable {
    let regularSizeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case regularSizeImageURL = "regular"
    }
}

struct RandomImage {
    let imageUrlString: String
    let imageRatio: Double
    let isStar: Bool
}
