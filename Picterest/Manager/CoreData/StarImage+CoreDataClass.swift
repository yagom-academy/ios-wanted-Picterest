//
//  StarImage+CoreDataClass.swift
//  Picterest
//
//  Created by J_Min on 2022/07/28.
//
//

import Foundation
import CoreData

protocol Image { }

public class StarImage: NSManagedObject {

}

extension StarImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarImage> {
        return NSFetchRequest<StarImage>(entityName: "StarImage")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageRatio: Double
    @NSManaged public var memo: String?
    @NSManaged public var networkURL: String?
    @NSManaged public var storageURL: String?

}

extension StarImage : Identifiable, Image {

}
