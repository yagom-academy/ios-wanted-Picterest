//
//  Picture+CoreDataProperties.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/26.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var imageSize: String?
    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var originUrl: String?
    @NSManaged public var localUrl: String?

}

extension Picture : Identifiable {

}
