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
    
    func makeEmptyObject() -> NSManagedObject? {
        guard let context = context,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return nil }

        let emptyObject = NSManagedObject(entity: entityDescription, insertInto: context)
        return emptyObject
    }
    
    func save(id: String, originalURL: String, memo: String, savedLocation: String) {
        guard let context = context,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }

        let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
        let keyArray = ["id", "memo", "originalURL", "savedLocation"]
        let valueArray = [id, memo, originalURL, savedLocation]

        for index in 0..<keyArray.count {
            newValue.setValue(valueArray[index], forKey: keyArray[index])
        }
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
            print("data count: \(results.count)")
            return results
        } catch {
            print("Could not retrieve")
        }
        
        return nil
    }
    
    func remove(_ item: NSManagedObject) {
        guard let context = context else { return }
        context.delete(item)
        print("remove Success")
    }
}
