//
//  CoreDataManager.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedPhoto")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("ERROR \(error.localizedDescription) 😳")
            }
        }
        return container
    }()
    private lazy var context = persistentContainer.viewContext
    
    func save(newPhoto: CoreSavedPhoto) {
        let entity = NSEntityDescription.entity(forEntityName: "SavedPhotoInfo", in: context)
        
        if let entity = entity {
            let savedPhoto = NSManagedObject(entity: entity, insertInto: context)
            savedPhoto.setValue(newPhoto.id, forKey: "id")
            savedPhoto.setValue(newPhoto.memo, forKey: "memo")
            savedPhoto.setValue(newPhoto.url, forKey: "url")
            savedPhoto.setValue(newPhoto.path, forKey: "path")
        }
        
        do {
            try context.save()
        } catch {
            print("ERROR \(error.localizedDescription) 🥵")
        }
    }
    
    func fetch() -> [CoreSavedPhoto] {
        do {
            return try context.fetch(SavedPhotoInfo.fetchRequest()).map {
                CoreSavedPhoto(
                    id: $0.id ?? "",
                    memo: $0.memo ?? "",
                    url: $0.url ?? "",
                    path: $0.path ?? ""
                )
            }
        } catch {
            return []
        }
    }
    
    func remove(id: String) {
        let aa = fetchObject().filter { $0.id == id }.first
        context.delete(aa!)
        
        do {
            try context.save()
        } catch {
            print("ERROR \(error.localizedDescription) 💀")
        }
    }
    
    private func fetchObject() -> [SavedPhotoInfo] {
        do {
            return try context.fetch(SavedPhotoInfo.fetchRequest())
        } catch {
            return []
        }
    }
}
