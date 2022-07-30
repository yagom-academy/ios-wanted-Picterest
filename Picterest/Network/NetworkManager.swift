//
//  NetworkManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation
import UIKit

let CLIENT_ID = "-zl2niPFVFHI-v3tBrXmhFXu3tGrW8qQbg55-dkXJPU"

enum NetworkError: Error {
    case url
    case network(error: Error?)
    case decode(error: Error?)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    var page = 1
    
    func fetchImageList(completion: @escaping (Result<[ImageModel],NetworkError>)->Void){
        
        let urlStr = "https://api.unsplash.com/photos/?client_id=\(CLIENT_ID)&per_page=15&page=\(page)"
        guard let url = URL(string: urlStr) else {
            completion(.failure(.url))
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(.network(error: error)))
                return
            }
            let decorder = JSONDecoder()
            guard let data = try? decorder.decode([ImageModel].self, from: data) else {
                completion(.failure(.decode(error: error)))
                return
            }
            completion(.success(data))
        }.resume()
        page += 1
        
    }
    
    func fetchImage(url: String, completion: @escaping (UIImage)->Void){
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
                completion(image)
        }
        CacheManager.shared.urlCache.getCachedResponse(for: dataTask) { response in
            guard let response = response else {
                dataTask.resume()
                return
            }
            guard let image = UIImage(data: response.data) else { return }
            completion(image)
        }
    }
}
