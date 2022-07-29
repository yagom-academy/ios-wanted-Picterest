//
//  CoreDataManager.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import CoreData
import Foundation

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var imageInfoEntity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "ImageCoreInfo", in: context)
    }
    
    func saveImageInfo(_ info: CoreDataInfo) -> Bool {
        if let entity = imageInfoEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(info.id, forKey: "id")
            managedObject.setValue(info.message, forKey: "message")
            managedObject.setValue(info.aspectRatio, forKey: "aspectRatio")
            managedObject.setValue(info.imageURL, forKey: "imageURL")
            managedObject.setValue(info.imageFileLocation, forKey: "imageFileLocation")
            return saveToContext()
        }
        return false
    }
    
    private func saveToContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getImageInfos(completion: @escaping ([CoreDataInfo]) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var infos: [CoreDataInfo] = []
            let readResults = self.readImageInfos()
            for result in readResults {
                let info = CoreDataInfo(id: result.id ?? UUID(), message: result.message ?? "", aspectRatio: result.aspectRatio, imageURL: result.imageURL ?? "", imageFileLocation: result.imageFileLocation ?? "")
                infos.append(info)
            }
            completion(infos)
        }
    }
    
    func containImage(imageURL: String) -> Bool {
        let readResults = self.readImageInfos()
        var isContain = false
        for result in readResults {
            if result.imageURL == imageURL {
                isContain = true
                break
            }
        }
        return isContain
    }
    
    func readImageInfos() -> [ImageCoreInfo] {
        do {
            let request = ImageCoreInfo.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error)
        }
        return []
    }
    
    func removeAllImageInfos() -> Bool {
        let readInfos = readImageInfos()
        for info in readInfos {
            context.delete(info)
        }
        return saveToContext() && readInfos.isEmpty
    }
    
    func removeImageInfo(at id: UUID) throws -> String {
        let readInfos = readImageInfos()
        var result: String?
        for info in readInfos {
            if (info.id == id) {
                guard let imageFileLocation = info.imageFileLocation else { break }
                context.delete(info)
                if saveToContext() {
                    result = imageFileLocation
                    break
                } else {
                    throw DBManagerError.failToRemoveImageInfo
                }
            }
        }
        guard let result = result else {
            throw DBManagerError.failToRemoveImageInfo
        }
        return result
    }
}
