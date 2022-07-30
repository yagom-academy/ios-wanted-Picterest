//
//  Collection+Custom.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
