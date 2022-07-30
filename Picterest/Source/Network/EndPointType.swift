//
//  EndPointType.swift
//  Picterest
//
//  Created by 이윤주 on 2022/07/28.
//

import Alamofire

protocol EndPointType: URLRequestConvertible {

    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }

}

extension EndPointType {

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        return urlRequest
    }

}
