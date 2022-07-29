//
//  URLComponents+.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
