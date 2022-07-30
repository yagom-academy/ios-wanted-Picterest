//
//  Encodable+.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/25.
//

import Foundation

extension Encodable {
    func toDicionary() throws -> [String:Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
