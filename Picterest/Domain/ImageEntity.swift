//
//  ImageEntity.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

final class ImageEntity: Identifiable {  
  let id: String
  let imageURL: URL
  let width: CGFloat
  let height: CGFloat
  private(set) var isLiked: Bool
  private(set) var memo: String
  private(set) var image: UIImage?
  private(set) var storedDirectory: URL?
  
  init(id:String, imageURL:URL, memo: String, isLiked: Bool, width: CGFloat, height: CGFloat ){
    self.id = id
    self.memo = memo
    self.isLiked = isLiked
    self.imageURL = imageURL
    self.width = width
    self.height = height
  }
  
}

extension ImageEntity {
  
  func changePersonalizedStatus(completion: (Bool) -> String) {
    self.isLiked = !isLiked
    self.memo = completion(self.isLiked)
  }
  
  func saveImage(image:UIImage) {
    self.image = image
  }
  
  func saveStoredDirectory(url: URL) {
    self.storedDirectory = url
  }
  
}
