//
//  SavedModel+CoreDataProperties.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/28.
//
//

import Foundation
import CoreData
import UIKit


struct savedModel {
    static let downloadManager = DownLoadManager()
    var id: String?
    var memo: String?
    var file: String?
    var raw: String?
    
    var image: UIImage? {
        guard let imageData = DownLoadManager().fetchData(file ?? "") else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    var memoDescription: String {
        guard let memo = memo else {
            return ""
        }
        return memo
    }
}

extension SavedModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedModel> {
        return NSFetchRequest<SavedModel>(entityName: "SavedModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var memo: String?
    @NSManaged public var fileURL: String?
    @NSManaged public var rawURL: String?

}

extension SavedModel : Identifiable {

}
