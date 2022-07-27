//
//  HomeViewModel.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation
import UIKit

final class HomeViewModel {
  
  var imageList: Observable<[ImageEntity]> = Observable([])
  let repository = HomeRepository()
  let imagesPerPage = 15
  
  subscript(index: IndexPath) -> ImageEntity? {
    return imageList.value[index.row]
  }
  
  func pageCount() -> Int {
    return self.imageList.value.count / imagesPerPage
  }
  
  func fetchImages(count: Int = 15) {
    let page = pageCount() + 1 
    let endPoint = EndPoint(path: .showList, query: .imagesPerPage(pageNumber: page, perPage: count))
    repository.fetchImages(endPoint: endPoint) { result in
      switch result {
      case .success(let data):
        for item in data {
          let imageNumber = self.imageList.value.count + 1
          let imageEntity = item.toDomain(index: imageNumber)
          self.imageList.value.append(imageEntity)
        }
      case .failure(let error):
        print(error)
      }
    }
  }

}

