//
//  CoreDataManager.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import CoreData
import Foundation

class CoreDataManager {
    private enum NameSpace {
        static let persistentContainerName = "Model"
        static let imageInfoEntityName = "ImageCoreInfo"
        static let idKey = "id"
        static let messageKey = "message"
        static let aspectRatioKey = "aspectRatio"
        static let imageURLKey = "imageURL"
        static let imageFileLocation = "imageFileLocation"
    }
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: NameSpace.persistentContainerName)
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
        return  NSEntityDescription.entity(forEntityName: NameSpace.imageInfoEntityName, in: context)
    }
    
    func saveImageInfo(_ info: CoreDataInfo) -> Bool {
        if let entity = imageInfoEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(info.id, forKey: NameSpace.idKey)
            managedObject.setValue(info.message, forKey: NameSpace.messageKey)
            managedObject.setValue(info.aspectRatio, forKey: NameSpace.aspectRatioKey)
            managedObject.setValue(info.imageURL, forKey: NameSpace.imageURLKey)
            managedObject.setValue(info.imageFileLocation, forKey: NameSpace.imageFileLocation)
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
                guard let id = result.id,
                      let message = result.message,
                      let imageURL = result.imageURL,
                      let imageFileLocation = result.imageFileLocation else { continue }
                let info = CoreDataInfo(id: id, message: message, aspectRatio: result.aspectRatio, imageURL: imageURL, imageFileLocation: imageFileLocation)
                infos.append(info)
            }
            completion(infos)
        }
    }
    
    func containImage(imageURL: String) -> Bool {
        let readInfos = self.readImageInfos()
        var isContainImage = false
        for info in readInfos {
            if info.imageURL == imageURL {
                isContainImage = true
                break
            }
        }
        return isContainImage
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
