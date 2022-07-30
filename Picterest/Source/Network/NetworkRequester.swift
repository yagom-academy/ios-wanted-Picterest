//
//  NetworkRequester.swift
//  Picterest
//
//  Created by 이윤주 on 2022/07/30.
//

import Foundation

enum NetworkError: LocalizedError {

    case invalidURL
    case requestFail(Error)
    case invalidResponse
    case failedResponse(statusCode: Int)
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFail:
            return "HTTP 요청에 실패했습니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .failedResponse(let statusCode):
            return "(\(statusCode)) 실패한 상태 코드를 받았습니다."
        case .emptyData:
            return "데이터가 존재하지 않습니다."
        }
    }
}

typealias SessionResult = (Result<Data, NetworkError>) -> Void

struct NetworkRequester {

    // MARK: Properties

    private let session: URLSession = .shared
    private let successStatusCode: Range<Int> = (200 ..< 300)

    // MARK: Networking methods

    func request(
        to urlString: String,
        completion: @escaping SessionResult
    ) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        let request = URLRequest(url: url)
        return dataTask(with: request, completion: completion)
    }
    
    func request(
        to endPoint: EndPointType,
        completion: @escaping SessionResult
    ) {
        guard let urlRequest = try? endPoint.asURLRequest() else {
            completion(.failure(.invalidURL))
            return
        }

        dataTask(with: urlRequest, completion: completion).resume()
    }

    private func dataTask(
        with request: URLRequest,
        completion: @escaping SessionResult
    ) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFail(error)))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard self.successStatusCode.contains(httpResponse.statusCode) else {
                completion(.failure(.failedResponse(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            completion(.success(data))
        }
        return task
    }
}
