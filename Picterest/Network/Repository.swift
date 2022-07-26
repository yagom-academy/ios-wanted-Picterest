//
//  Repository.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import Foundation

class Repository {
    
    private let accessKey = "wJsTICYs3d4ZfPFW_KsRfXmdKOaCzCKPDjSpFFyAeEQ"
    
    private let httpClient = HttpClient()
    
    func fetchImage(completion: @escaping (Result<[ImageData], NetworkError>) -> Void) -> Void {
        
        let params: [String:Any] = ["client_id": accessKey, "page": 1, "count": 15]
        
        httpClient.getImageData(path: "/random", params: params) { result in
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
    
    
    func fetchNextImageData(page: Int, completion: @escaping (Result<[ImageData], NetworkError>) -> Void) {
        let params: [String:Any] = ["client_id": accessKey, "page": page, "count": 15]
        httpClient.getImageData(path: "/random", params: params) { result in
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
