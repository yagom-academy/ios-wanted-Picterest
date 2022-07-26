//
//  Photo.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

struct Photo: Codable {
    let id: String
    let width: Double
    let height: Double
    let urls: Urls
}

struct Urls: Codable {
    let small: String
    let full: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        full = try container.decode(String.self, forKey: .full)
        small = try container.decode(String.self, forKey: .small)
    }
}

