//
//  PhotoInfoRequestDTO.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation

enum OrderBy: String, Encodable {
    case latest
    case oldest
    case popular
}

struct PhotoInfoRequestDTO: Encodable {
    let page: Int
    var perPage: Int = 15
    var orderBy: OrderBy = .oldest
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case orderBy = "order_by"
    }
}
