//
//  Photo.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation

struct Photo : Decodable {
    let id : String
    let width : Int
    let height : Int
    let urls : Urls
}

struct Urls : Decodable {
    let raw : String
    let small : String
}
