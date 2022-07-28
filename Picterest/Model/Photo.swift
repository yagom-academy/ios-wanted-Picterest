//
//  Photo.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let width: Double
    let height: Double
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Double.self, forKey: .width)
        height = try container.decode(Double.self, forKey: .height)
        urls = try container.decode(Urls.self, forKey: .urls)
    }
}

struct Urls: Decodable {
    let small: String
    let full: String
}
