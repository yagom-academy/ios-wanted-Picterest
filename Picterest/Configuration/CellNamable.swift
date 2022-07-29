//
//  CellNamable.swift
//  Picterest
//
//

import Foundation

protocol CellNamable {
    static var identifier: String { get }
}

extension CellNamable {
    static var identifier: String { String(describing: Self.self) }
}
