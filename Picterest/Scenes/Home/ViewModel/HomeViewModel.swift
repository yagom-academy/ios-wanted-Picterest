//
//  HomeViewModel.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation

final class HomeViewModel {
  
  var imageList: Observable<[ImageEntity]>?
  let repository = HomeRepository()
  
  
  subscript(index: IndexPath) -> ImageEntity? {
    return imageList?.value[index.item]
  }
  
  func fetchImages(count: Int?) {
    let endPoint = EndPoint(path: .showList, query: .imagesPerPage())
    repository.fetchImages(endPoint: endPoint) { result in
      switch result {
      case .success(let data):
        for (index, item) in data.enumerated() {
          let imageEntity = item.toDomain(index: index + 1)
          self.imageList?.value.append(imageEntity)
        }
      case .failure(let error):
        print(error)
      }
    }
  }

}
