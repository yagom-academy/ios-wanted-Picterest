//
//  PhotoListProvider.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import Foundation

protocol PhotoListAPIProviderType {
    
    func fetchPhotoList(
        completion: @escaping (Result<PhotoListResult, Error>
        ) -> Void)
    
}

struct PhotoListAPIProvider: PhotoListAPIProviderType {
    
    let networkRequester: NetworkRequesterType
    
    func fetchPhotoList(
        completion: @escaping (Result<PhotoListResult, Error>
        ) -> Void) {
        networkRequester.request(to: PhotoListEndPoint.getPhotoList) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(PhotoListResult.self, from: data) else {
                    return
                }
                completion(.success(decodedData))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

