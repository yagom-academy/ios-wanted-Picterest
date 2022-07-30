//
//  CoreDataManager.swift
//  Picterest
//
//  Created by oyat on 2022/07/30.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var imageInfoEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "ImageInfoEntity", in: context)
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func createImageInfo(id: String, memo: String, originUrl: String, savePath: String, width: CGFloat, height: CGFloat) {
        if let entity = imageInfoEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(id, forKey: "id")
            managedObject.setValue(memo, forKey: "memo")
            managedObject.setValue(originUrl, forKey: "originUrl")
            managedObject.setValue(savePath, forKey: "savePath")
            managedObject.setValue(width, forKey: "width")
            managedObject.setValue(height, forKey: "height")
            saveToContext()
        }
    }
    
    func isSavedImage(originUrl: String) -> Bool {
        let fetchResults = fetchImageInfo()
        var isSavedImage = false
        for result in fetchResults {
            if result.originUrl == originUrl {
                isSavedImage = true
                break
            }
        }
        return isSavedImage
    }
    
    // MARK: - Read 구현
    func fetchImageInfo() -> [ImageInfoEntity] {
        do {
            let request = ImageInfoEntity.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func getImageInfos() -> [CoreDataInfo] {
        var coreDataInfoList: [CoreDataInfo] = []
        let fetchResults = fetchImageInfo()
        for result in fetchResults {
            guard let id = result.id,
                  let memo = result.memo,
                  let originUrl = result.originUrl,
                  let savePath = result.savePath,
                  let width = Int(result.width ?? ""),
                  let height = Int(result.height ?? "") else { continue }
            
            let coreDataInfo = CoreDataInfo(id: id, memo: memo, originUrl: originUrl, savePath: savePath, width: width, height: height)
            coreDataInfoList.append(coreDataInfo)
        }
        return coreDataInfoList
    }
    
    // MARK: - Core Data Saving support
    func saveToContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Update 구현
    func updateCoreDataInfo(_ coreDataInfo: CoreDataInfo) {
        let fetchResults = fetchImageInfo()
        for result in fetchResults {
            if result.id == coreDataInfo.id {
                result.memo = "업데이트 메모"
            }
        }
        saveToContext()
    }
    
 // MARK: - Delete 구현 ,  값 변경 후 context에 저장
    
    //coreDataInfo를 받아 해당 coreDataInfo 삭제, id는 고유값
    func deleteCoreDataInfo(_ coreDataInfo: CoreDataInfo) {
        let fetchResults = fetchImageInfo()
        let coreDataInfo = fetchResults.filter({ $0.id == coreDataInfo.id })[0]
        context.delete(coreDataInfo)
        saveToContext()
    }
    
    //코어데이터에 있는 imageInfo관련 정보 다 삭제
    func deleteAllCoreDataInfos() {
        let fetchResult = fetchImageInfo()
        for result in fetchResult {
            context.delete(result)
        }
    }
    
    
}
