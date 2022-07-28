//
//  Collection+Extension.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
