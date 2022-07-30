//
//  Provider.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation

protocol Provider {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E, completion: @escaping (Result<R, Error>) -> Void) where E.Response == R

    func request(_ url: URL, completion: @escaping (Result<Data, Error>) -> ())
}
