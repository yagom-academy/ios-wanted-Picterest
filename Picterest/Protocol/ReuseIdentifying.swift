//
//  ReuseIdentifying.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
