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
    var coreDataArray = [NSManagedObject]()
    
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
    }
}

// MARK: - Method

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
            coreDataArray.append(newValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(completion: () -> Void) {
        guard let context = context else { return }
        
        let fetchRequest = NSFetchRequest<ImageCoreData>(entityName: entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            coreDataArray = results
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func remove(_ item: NSManagedObject) {
        guard let context = context,
              let index = coreDataArray.firstIndex(of: item) else {
            return
        }
    
        context.delete(item)
    
        do {
            try context.save()
            coreDataArray.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

