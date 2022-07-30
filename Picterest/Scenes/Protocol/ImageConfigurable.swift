//
//  ImageConfigurable.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/30.
//

import Foundation

protocol ImageConfigurable {
  var imageList: Observable<[ImageEntity]> {get set}
  func fetchImages()
  func resetList()
  func updateLikeStatus()
  func resetLikeStatus()
  func toogleLikeState(item entity: ImageEntity, completion: @escaping ((Error?) -> Void))
  subscript(index: IndexPath) -> ImageEntity? { get }
}
