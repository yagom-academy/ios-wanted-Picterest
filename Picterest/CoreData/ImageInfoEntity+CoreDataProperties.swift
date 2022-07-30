//
//  ImageInfoEntity+CoreDataProperties.swift
//  Picterest
//
//  Created by oyat on 2022/07/30.
//
//

import Foundation
import CoreData


extension ImageInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageInfoEntity> {
        return NSFetchRequest<ImageInfoEntity>(entityName: "ImageInfoEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var originUrl: String?
    @NSManaged public var savePath: String?
    @NSManaged public var width: String?
    @NSManaged public var height: String?

}

extension ImageInfoEntity : Identifiable {

}
