//
//  CoreDataManager.swift
//  Picterest
//
//  Created by BH on 2022/07/30.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PhotoModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataManager {
    
    func save(
        id: String,
        imagePath: String,
        imageURL: String,
        memo: String,
        width: Int,
        height: Int
    ) {
        let context = persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: "PhotoEntity",
            in: context
        ) else { return }
        let image = NSManagedObject(entity: entityDescription, insertInto: context)
        
        image.setValue(id, forKey: "id")
        image.setValue(imagePath, forKey: "imagePath")
        image.setValue(imageURL, forKey: "imageURL")
        image.setValue(memo, forKey: "memo")
        image.setValue(width, forKey: "width")
        image.setValue(height, forKey: "height")
        
        do {
            try context.save()
        } catch {
            print("saving error")
        }
    }
    
    func load() -> [NSManagedObject]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
            
        } catch {
            print("Could not retrieve")
        }
        return nil
    }
    
    func delete(item: NSManagedObject) {
        let context = persistentContainer.viewContext
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("failed delete")
        }
    }
}
