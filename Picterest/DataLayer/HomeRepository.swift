//
//  HomeRepository.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation

struct HomeRepository {
  
  func fetchImages(endPoint: EndPoint, completion: @escaping (Result<[ImageDTO], NetworkError>) -> Void) {
    let request = Requset(requestType: .get, body: nil, endPoint: endPoint)
    NetworkService.request(on: request.value) { result in
      switch result {
      case .success(let data):
        let decorder = Decoder<[ImageDTO]>()
        guard let decodedData = decorder.decode(data: data) else {return}
        completion(.success(decodedData))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func saveImage(imageEntity: ImageEntity) {
    ImageManager.shared.saveImage(imageEntity)
  }
  
  
}
