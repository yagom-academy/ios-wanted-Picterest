//
//  CoreDataManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    let modelName: String = "ImageInfo"
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    func loadData() -> [ImageInfo] {
        var imageInfoList: [ImageInfo] = []
        guard let context = context else { return [] }
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        let dateOrder = NSSortDescriptor(key: "saveDate", ascending: false)
        request.sortDescriptors = [dateOrder]
        do {
            guard let fetchedImageInfoList = try context.fetch(request) as? [ImageInfo] else { return [] }
            imageInfoList = fetchedImageInfoList
            print(imageInfoList)
            print("코어데이터 로드 성공")
        } catch {
            print("코어데이터 로드 실패")
        }
        return imageInfoList
    }
    
    func saveData(data: ImageViewModel, memo: String, localPath: String) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context),
              let imageInfo = NSManagedObject(entity: entity, insertInto: context) as? ImageInfo else { return }
        imageInfo.saveDate = Date()
        imageInfo.id = data.id
        imageInfo.url = data.url
        imageInfo.memo = memo
        imageInfo.localPath = localPath
        print("코어데이터 추가 완료")
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
            print("코어데이터 삭제 완료")
        } catch {
            print("코어데이터 삭제 실패")
        }
        appDelegate?.saveContext()
    }
    
    func updateData(id: String, memo: String) {
        guard let context = context else { return }
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let fetchedImageInfoList = try context.fetch(request) as? [ImageInfo],
                  let targetData = fetchedImageInfoList.first else { return }
            targetData.memo = memo
            print("코어데이터 업데이트 성공")
        } catch {
            print("코어데이터 업데이트 실패")
        }
        appDelegate?.saveContext()
    }
}
