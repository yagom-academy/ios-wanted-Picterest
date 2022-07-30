//
//  Decoder.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation

struct Decoder<T: Decodable> {
    
    typealias Model = T
    
    func decode(data: Data) -> Result<Model, Error> {
        do {
            let decodedData = try JSONDecoder().decode(Model.self, from: data)
            return .success(decodedData)
        } catch {
            print(NetworkError.decodingError(error))
            return .failure(NetworkError.emptyData)
        }
    }
}
