//
//  PhotoResponse.swift
//  Picterest
//
//  Created by 이윤주 on 2022/07/30.
//

import Foundation

struct PhotoResponse: Decodable {
    
    var id: String
    var photoURL: PhotoURL
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoURL = "urls"
    }
    
}
