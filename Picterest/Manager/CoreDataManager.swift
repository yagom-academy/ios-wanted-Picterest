//
//  CoreDataManager.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/28.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavePhoto")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createSavePhoto(_ id: String, _ memo: String, _ originUrl: String, _ location: String, _ ratio: Double) {
        let entity = NSEntityDescription.entity(forEntityName: "SavePhoto", in: context)

        if let entity = entity {
            let savePhoto = NSManagedObject(entity: entity, insertInto: context)
            savePhoto.setValue(id, forKey: "id")
            savePhoto.setValue(memo, forKey: "memo")
            savePhoto.setValue(originUrl, forKey: "originUrl")
            savePhoto.setValue(location, forKey: "location")
            savePhoto.setValue(ratio, forKey: "ratio")

            saveContext()
        }
    }
    
    func fetchSavePhoto() -> [SavePhoto] {
        var photos: [SavePhoto] = []
        
        let request: NSFetchRequest<SavePhoto> = SavePhoto.fetchRequest()
        do {
            photos = try context.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return photos
    }
    
    func deleteSavePhoto(_ entity: SavePhoto) {
        context.delete(entity)
        
        saveContext()
    }
}
