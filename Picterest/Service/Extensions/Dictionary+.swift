//
//  Dictionary+.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/29.
//

import Foundation

extension Dictionary where Key == String , Value == String {
    func configureQuerys() -> [URLQueryItem] {
        return self.map {
            URLQueryItem(name: $0, value: $1)
        }
    }
}
