//
//  NetworkManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation

let CLIENT_ID = "-zl2niPFVFHI-v3tBrXmhFXu3tGrW8qQbg55-dkXJPU"

enum NetworkError: Error {
    case url
    case network(error: Error?)
    case decode(error: Error?)
}

final class NetworkManager {
    func fetchRandomImages(completion: @escaping (Result<[Image],NetworkError>)->Void){
        let urlStr = "https://api.unsplash.com/photos/random/?client_id=\(CLIENT_ID)&count=15"
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
            guard let data = try? decorder.decode([Image].self, from: data) else {
                completion(.failure(.decode(error: error)))
                return
            }
            completion(.success(data))
        }.resume()
        
    }
}
