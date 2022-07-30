//
//  Picterest+CoreDataProperties.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//
//

import Foundation
import CoreData


extension Picterest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picterest> {
        return NSFetchRequest<Picterest>(entityName: "Picterest")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var url: String?
    @NSManaged public var path: String?
    @NSManaged public var width: Int32
    @NSManaged public var height: Int32

}

extension Picterest : Identifiable {

}
