//
//  Photo.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation

struct PhotoList : Decodable {
    var photoList : [Photo]
}

struct Photo : Decodable {
    let id : String
    let height : Int
    let urls : Urls
}

struct Urls : Decodable {
    let raw : String
}
