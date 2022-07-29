//
//  CoreDataManager.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedPhoto")
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("ERROR \(error.localizedDescription) 😳")
            }
        }
        return container
    }()
    private lazy var context = persistentContainer.viewContext
    
    private init() {}
    
    func save(newPhoto: CoreSavedPhoto) {
        let entity = NSEntityDescription.entity(forEntityName: "SavedPhotoInfo", in: context)
        
        if let entity = entity {
            let savedPhoto = NSManagedObject(entity: entity, insertInto: context)
            savedPhoto.setValue(newPhoto.id, forKey: "id")
            savedPhoto.setValue(newPhoto.memo, forKey: "memo")
            savedPhoto.setValue(newPhoto.url, forKey: "url")
            savedPhoto.setValue(newPhoto.path, forKey: "path")
            savedPhoto.setValue(newPhoto.ratio, forKey: "ratio")
        }
        
        do {
            try context.save()
        } catch {
            debugPrint("ERROR \(error.localizedDescription) 🥵")
        }
    }
    
    func fetch() -> [CoreSavedPhoto] {
        do {
            return try context.fetch(SavedPhotoInfo.fetchRequest()).map {
                CoreSavedPhoto(
                    id: $0.id ?? "",
                    memo: $0.memo ?? "",
                    url: $0.url ?? "",
                    path: $0.path ?? "",
                    ratio: $0.ratio
                )
            }
        } catch {
            return []
        }
    }
    
    func remove(id: String) {
        guard let willRemoveItem = fetchObject().filter ({ $0.id == id }).first else { return }
        context.delete(willRemoveItem)
        
        do {
            try context.save()
        } catch {
            debugPrint("ERROR \(error.localizedDescription) 💀")
        }
    }
    
//    func removeAll() {
//        let request: NSFetchRequest<NSFetchRequestResult> = SavedPhotoInfo.fetchRequest()
//        let delete = NSBatchDeleteRequest(fetchRequest: request)
//
//        do {
//            try context.execute(delete)
//        } catch {
//            debugPrint("ERROR \(error.localizedDescription) 👊")
//        }
//    }
    
    private func fetchObject() -> [SavedPhotoInfo] {
        do {
            return try context.fetch(SavedPhotoInfo.fetchRequest())
        } catch {
            return []
        }
    }
}
