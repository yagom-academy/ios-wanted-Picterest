//
//  PhotoListResult.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import Foundation

struct PhotoListResult: Decodable {
    
    let id: String
    let width: Int
    let height: Int
    let urls: PhotoURL
    
}

