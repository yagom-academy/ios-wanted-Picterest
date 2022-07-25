//
//  RandomImage.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation

struct RandomImage: Codable {
    let id: String
    let urls: RandomImageURL
}

struct RandomImageURL: Codable {
    let smallSizeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case smallSizeImageURL = "full"
    }
}
