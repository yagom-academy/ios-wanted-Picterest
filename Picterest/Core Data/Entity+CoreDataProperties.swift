//
//  Entity+CoreDataProperties.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var path: String?
    @NSManaged public var url: String?

}

extension Entity : Identifiable {

}
