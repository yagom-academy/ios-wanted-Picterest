//
//  ImageInfo+CoreDataProperties.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//
//

import Foundation
import CoreData


extension ImageInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageInfo> {
        return NSFetchRequest<ImageInfo>(entityName: "ImageInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var localPath: String?
    @NSManaged public var memo: String?
    @NSManaged public var saveDate: Date?
    @NSManaged public var url: String?
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16

}

extension ImageInfo : Identifiable {

}
