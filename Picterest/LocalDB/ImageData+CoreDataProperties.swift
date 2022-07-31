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
    guard let memo = self.memo,
          let storedDirectory = self.storedDirectory
    else {return nil}
    return ImageEntity(id: self.id, imageURL: self.imageURL, isLiked: true, memo: memo, storedDirectory: storedDirectory)
  }
  
}
