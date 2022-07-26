//
//  QueryMaker.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation

enum QueryMaker {
  
  static let defaultAPIKEY: String? = Bundle.searchObject(from: "API", key: "key")
  
  case imagesPerPage(Int)
  case noQuery
  
  var queryItems: [URLQueryItem]? {
    guard let APIKey = QueryMaker.defaultAPIKEY else {return nil}
    var baseQuery: [URLQueryItem] = [URLQueryItem(name: Query.clientID.rawValue,
                                                  value: APIKey)]
    switch self {
    case .imagesPerPage(let ImagePerPage):
      baseQuery.append(URLQueryItem(name: Query.perPage.rawValue,
                                    value: "\(ImagePerPage)"))
      return baseQuery
    case .noQuery:
      return nil
    }
  }
}
