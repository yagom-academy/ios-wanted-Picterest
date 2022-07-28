//
//  SavePhoto+CoreDataProperties.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/28.
//
//

import Foundation
import CoreData


extension SavePhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavePhoto> {
        return NSFetchRequest<SavePhoto>(entityName: "SavePhoto")
    }

    @NSManaged public var id: String?
    @NSManaged public var location: String?
    @NSManaged public var memo: String?
    @NSManaged public var originUrl: String?
    @NSManaged public var ratio: Double

}

extension SavePhoto : Identifiable {

}
