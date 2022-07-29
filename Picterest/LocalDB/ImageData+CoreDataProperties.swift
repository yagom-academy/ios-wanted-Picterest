//
//  ImageData+CoreDataProperties.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/28.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

}

extension ImageData : Identifiable {
  
  func toDomain() -> ImageEntity? {
    guard let id = self.id,
          let imageURL = self.imageURL,
          let memo = self.memo,
          let storedDirectory = self.storedDirectory
    else {return nil}
    return ImageEntity(id: id, imageURL: imageURL, isLiked: true, memo: memo, storedDirectory: storedDirectory)
  }
  
}
