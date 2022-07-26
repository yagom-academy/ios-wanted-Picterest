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

class NetworkManager {
    func getPhotoList(completion: @escaping (Result<[PhotoModel], NetworkError>) -> Void) {
        let session = URLSession(configuration: .default)
        var components = URLComponents(string: Constant.BASE_URL)
        let clientID = URLQueryItem(name: "client_id", value: PicterestKey.appKey)
        let count = URLQueryItem(name: "count", value: "15")
        components?.queryItems = [clientID, count]
        
        guard let url = components?.url else { return  completion(.failure(.badUrl)) }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return completion(.failure(.noData)) }
            print(data)
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


