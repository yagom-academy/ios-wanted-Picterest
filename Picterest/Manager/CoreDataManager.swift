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

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createSavePhoto(_ id: String, _ memo: String, _ originUrl: String, _ location: String) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavePhoto", in: context)

        if let entity = entity {
            let savePhoto = NSManagedObject(entity: entity, insertInto: context)
            savePhoto.setValue(id, forKey: "id")
            savePhoto.setValue(memo, forKey: "memo")
            savePhoto.setValue(originUrl, forKey: "originUrl")
            savePhoto.setValue(location, forKey: "location")

            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
}
