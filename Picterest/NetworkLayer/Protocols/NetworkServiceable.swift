//
//  NetworkServiceable.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation

protocol NetworkServiceable {
  func request(on endPoint: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
