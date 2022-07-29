//
//  HomeViewModel.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

protocol ImageConfigurable {
  var imageList: Observable<[ImageEntity]> {get set}
  func fetchImages()
  func toogleLikeState(item entity: ImageEntity, completion: @escaping ((Error?) -> Void))
  subscript(index: IndexPath) -> ImageEntity? { get }
}


final class HomeViewModel: ImageConfigurable {
  
  var imageList: Observable<[ImageEntity]> = Observable([])
  let repository = HomeRepository()
  private(set) var imagesPerPage = 15
  
  subscript(index: IndexPath) -> ImageEntity? {
    return imageList.value[index.row]
  }
  

  func fetchImages() {
    let page = pageCount() + 1
    let endPoint = EndPoint(path: .showList, query: .imagesPerPage(pageNumber: page, perPage: imagesPerPage))
    repository.fetchImages(endPoint: endPoint) { result in
      switch result {
      case .success(let data):
        for item in data {
//          let imageNumber = self.imageList.value.count + 1
          let imageEntity = item.toDomain()
          self.imageList.value.append(imageEntity)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func toogleLikeState(item entity: ImageEntity, completion: @escaping ((Error?) -> Void)) {
    entity.toogleLikeStates()
    repository.saveImage(imageEntity: entity){ error in
      if let error = error {
        completion(error)
      }else {
        completion(nil)
      }
    }
  }

}

private extension HomeViewModel {
  func pageCount() -> Int {
    return self.imageList.value.count / imagesPerPage
  }
}
