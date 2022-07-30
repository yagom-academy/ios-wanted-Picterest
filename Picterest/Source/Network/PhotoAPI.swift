//
//  PhotoAPI.swift
//  Picterest
//
//  Created by 이윤주 on 2022/07/29.
//

import Alamofire
import Foundation

struct PhotoAPI {
    
    let networkRequester = NetworkRequester()

    func fetch(
        completion: @escaping (Result<[PhotoResponse], Error>) -> Void
    ) {
        networkRequester.request(to: PhotoEndpoint.getPhoto) { result in
            switch result {
            case .success(let data):
                guard let decoded = try? JSONDecoder().decode([PhotoResponse].self, from: data)
                else { return }
                completion(.success(decoded))
            case .failure(let error):
                completion(error)
            }
        }
    }

}
