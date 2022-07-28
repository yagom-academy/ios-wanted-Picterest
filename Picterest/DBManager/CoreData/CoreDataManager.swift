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
    
    func getImageInfos() -> [CoreDataInfo] {
        var infos: [CoreDataInfo] = []
        let readResults = readImageInfos()
        for result in readResults {
            let info = CoreDataInfo(id: result.id ?? UUID(), message: result.message ?? "", imageURL: result.imageURL ?? "", imageFileLocation: result.imageFileLocation ?? "")
            infos.append(info)
        }
        return infos
    }
    
    private func readImageInfos() -> [ImageCoreInfo] {
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
        let readResults = readImageInfos()
        for result in readResults {
            context.delete(result)
        }
        return saveToContext() && readResults.isEmpty
    }
}
