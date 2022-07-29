//
//  CoreDataManager.swift
//  Picterest
//
//  Created by hayeon on 2022/07/27.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let entityName = "ImageCoreData"
    private let appDelegate: AppDelegate?
    private let context: NSManagedObjectContext?
    
    private init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
            self.appDelegate = appDelegate
            return
        }
        self.appDelegate = nil
        self.context = nil
        print("CoreDataManager: appDelegate Error")
    }
}

extension CoreDataManager {
    func save(id: String, originalURL: String, memo: String, savedLocation: String, imageHeight: Int, imageWidth: Int) {
        guard let context = context,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }

        let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
        newValue.setValue(id, forKey: CoreDataKey.id)
        newValue.setValue(memo, forKey: CoreDataKey.memo)
        newValue.setValue(originalURL, forKey: CoreDataKey.originalURL)
        newValue.setValue(savedLocation, forKey: CoreDataKey.savedLocation)
        newValue.setValue(imageHeight, forKey: CoreDataKey.imageHeight)
        newValue.setValue(imageWidth, forKey: CoreDataKey.imageWidth)
        
        do {
            try context.save()
            print("Save Success")
        } catch {
            print("Save Error")
        }
    }
    
    func load() -> [NSManagedObject]? {
        guard let context = context else { return nil }
        let fetchRequest = NSFetchRequest<ImageCoreData>(entityName: entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Could not retrieve")
        }
        
        return nil
    }
    
    func remove(_ item: NSManagedObject) {
        guard let context = context else { return }
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("remove error")
        }
        
    }
}
