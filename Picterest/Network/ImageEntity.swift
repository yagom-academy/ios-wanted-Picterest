//
//  ImageEntity.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import Foundation

struct ImageEntity: Codable {
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

struct ImageURL: Codable {
    var thumbnail: String
    var small: String
    var medium: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbnail = "thumb"
        case small
        case medium = "regular"
    }
}

struct Author: Codable {
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

struct Profile: Codable {
    var url: String
    private enum CodingKeys: String, CodingKey {
        case url = "medium"
    }
}


struct ImageModel {
    var imageURL: String
    var width: Int
    var height: Int
    var isSaved: Bool
}
