//
//  CoreDataManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private let modelName: String = "ImageInfo"
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func loadData() -> [ImageInfo] {
        var imageInfoList: [ImageInfo] = []
        guard let context = context else { return [] }
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        let dateOrder = NSSortDescriptor(key: "saveDate", ascending: false)
        request.sortDescriptors = [dateOrder]
        do {
            guard let fetchedImageInfoList = try context.fetch(request) as? [ImageInfo] else { return [] }
            imageInfoList = fetchedImageInfoList
        } catch {
            debugPrint("코어데이터 로드 실패")
        }
        return imageInfoList
    }
    
    func saveData(data: Image, memo: String, localPath: String) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context),
              let imageInfo = NSManagedObject(entity: entity, insertInto: context) as? ImageInfo else { return }
        imageInfo.saveDate = Date()
        imageInfo.id = data.id
        imageInfo.width = Int16(data.width)
        imageInfo.height = Int16(data.height)
        imageInfo.url = data.urls.small
        imageInfo.memo = memo
        imageInfo.localPath = localPath
        appDelegate?.saveContext()
    }
    
    func deleteData(id: String) {
        guard let context = context else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let fetchedImageInfoList = try context.fetch(request) as? [ImageInfo],
                  let targetData = fetchedImageInfoList.first else { return }
            context.delete(targetData)
        } catch {
            debugPrint("코어데이터 삭제 실패")
        }
        appDelegate?.saveContext()
    }
}
