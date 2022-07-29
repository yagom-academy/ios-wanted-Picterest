//
//  SaveViewModel.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/29.
//

import Foundation

final class SaveViewModel: ImageConfigurable {
  
  var imageList: Observable<[ImageEntity]> = Observable([])
  let repository = HomeRepository()
  
  subscript(index: IndexPath) -> ImageEntity? {
    return imageList.value[index.row]
  }
  
  func fetchImages() {
    let data = repository.fetchSavedImageData()
    var tempList: [ImageEntity] = []
    data.forEach({
      guard let imageEntity = $0.toDomain() else {return}
      tempList.append(imageEntity)
    })
    imageList.value = tempList
  }
  
  func toogleLikeState(item entity: ImageEntity, completion: @escaping ((Error?) -> Void)) {
    if entity.isLiked == false {
      repository.deleteImage(imageEntity: entity){ error in
        if let error = error {
          completion(error)
        }else {
          completion(nil)
        }
      }
    }
  }
  
}
