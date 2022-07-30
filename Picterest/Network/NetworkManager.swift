//
//  NetworkManager.swift
//  Picterest
//
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

final class NetworkManager {
    func getPhotoList(
        currentPage: Int,
        completion: @escaping (Result<[PhotoModel], NetworkError>) -> Void
    ) {
        let session = URLSession(configuration: .default)
        var components = URLComponents(string: Constant.BASE_URL)
        let clientID = URLQueryItem(name: "client_id", value: PicterestKey.appKey)
        let count = URLQueryItem(name: "per_page", value: "15")
        let page = URLQueryItem(name: "page", value: "\(currentPage)")
        components?.queryItems = [clientID, count, page]
        
        guard let url = components?.url else { return  completion(.failure(.badUrl)) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let photoData = try? JSONDecoder().decode([PhotoModel].self, from: data)
                if let photoData = photoData {
                    completion(.success(photoData))
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }
        dataTask.resume()
    }
}


