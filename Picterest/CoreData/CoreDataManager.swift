//
//  CoreDataManager.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/26.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private init() {}
    
    var container: NSPersistentContainer?
    
    var mainContext: NSManagedObjectContext {
        guard let context = container?.viewContext else {
            fatalError()
        }
        return context
    }
    
    func setup(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container?.loadPersistentStores(completionHandler: { (desc, error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func createPictureData(id: String, memo: String, originUrl: String, localUrl: String, imageSize: CGFloat) {
        mainContext.perform {
            
            let newPicture = Picture(context: self.mainContext)
            newPicture.id = id
            newPicture.memo = memo
            newPicture.originUrl = originUrl
            newPicture.localUrl = localUrl
            newPicture.imageSize = String(Int(imageSize))
            self.saveContext()
        }
    }
    
    func fetchPicture() -> [Picture] {
        var pictureList = [Picture]()
        mainContext.performAndWait {
            let request: NSFetchRequest<Picture> = Picture.fetchRequest()
            do {
                pictureList = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
        return pictureList
    }
    
    func searchPicture(id: String) -> Picture? {
        var pictureSet = [String: Picture]()
        mainContext.performAndWait {
            let request: NSFetchRequest<Picture> = Picture.fetchRequest()
            do {
                try mainContext.fetch(request).forEach {
                    guard let id = $0.id else { return }
                    pictureSet[id] = $0
                }
            } catch {
                print(error)
            }
        }
        return pictureSet[id]
    }
    
    func delete(entity: Picture) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveContext()
        }
    }
    
    func saveContext() {
        mainContext.perform {
            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
}
