//
//  ImageCoreInfo+CoreDataProperties.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/29.
//
//

import Foundation
import CoreData


extension ImageCoreInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCoreInfo> {
        return NSFetchRequest<ImageCoreInfo>(entityName: "ImageCoreInfo")
    }

    @NSManaged public var aspectRatio: Double
    @NSManaged public var id: UUID?
    @NSManaged public var imageFileLocation: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var message: String?

}

extension ImageCoreInfo : Identifiable {

}
