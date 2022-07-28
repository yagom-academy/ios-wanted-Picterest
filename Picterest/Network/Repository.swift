//
//  Repository.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import Foundation

class Repository {
    
    private let httpClient = HttpClient()
    
    func fetchImageData(_ method: ImageEndPoint, page: Int, completion: @escaping (Result<[ImageData], NetworkError>) -> Void) {
        let params: [String:Any] = ["client_id": method.accessKey, "page": page, "per_page": 15]
        httpClient.getImageData(baseUrl: method.baseUrl, path: "", params: params) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode([ImageData].self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodeError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
