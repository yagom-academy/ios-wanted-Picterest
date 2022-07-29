//
//  ImageDTO.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

struct ImageDTO: Decodable {
  let id: String
  let width: Int
  let height: Int
  let imageURL: ImageURL
  enum CodingKeys: String, CodingKey {
      case id, width, height
      case imageURL = "urls"
  }
}

struct ImageURL: Decodable {
  let url: URL
  enum CodingKeys: String, CodingKey {
      case url = "regular"
  }
}

extension ImageDTO {
  
  func toDomain() -> ImageEntity {
    return ImageEntity(id: self.id,
                       imageURL: self.imageURL.url,
                       isLiked: false,
                       width: CGFloat(self.width),
                       height: CGFloat(self.height))
  }
  
}
