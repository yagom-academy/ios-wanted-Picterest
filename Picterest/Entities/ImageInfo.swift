//
//  ImageInfo.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

struct ImageInfo: Decodable {
    var updatedAt: String
    var imageURL: ImageURL
    var author: Author
    var likes: Int
    var width: Int
    var height: Int
    
    private enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case imageURL = "urls"
        case author = "user"
        case likes, width, height
    }
}

struct ImageURL: Decodable {
    var thumbnail: String
    var small: String
    var medium: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbnail = "thumb"
        case small
        case medium = "regular"
    }
}

struct Author: Decodable {
    var username: String
    var name: String
    var portfolioURL: String?
    var profileImage: Profile
    
    private enum CodingKeys: String, CodingKey {
        case username, name
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
    }
}

struct Profile: Decodable {
    var url: String
    private enum CodingKeys: String, CodingKey {
        case url = "medium"
    }
}
