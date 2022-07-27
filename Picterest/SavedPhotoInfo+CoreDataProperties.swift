//
//  SavedPhotoInfo+CoreDataProperties.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//
//

import Foundation
import CoreData


extension SavedPhotoInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedPhotoInfo> {
        return NSFetchRequest<SavedPhotoInfo>(entityName: "SavedPhotoInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var url: String?
    @NSManaged public var path: String?
    @NSManaged public var ratio: Double

}

extension SavedPhotoInfo : Identifiable {

}
