//
//  ImageData+CoreDataProperties.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/28.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var orginUrl: String?
    @NSManaged public var locationUrl: String?
    @NSManaged public var ratio: Float

}

extension ImageData : Identifiable {

}
