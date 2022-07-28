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
    func save(_ data: ImageCoreDataModel) {
        guard let context = context,
              let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }

        let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
        let keyArray = ["id", "memo", "originalURL", "savedLocation"]
        let valueArray = [data.id, data.memo, data.originalURL, data.savedLocation]

        for index in 0..<keyArray.count {
            newValue.setValue(valueArray[index], forKey: keyArray[index])
        }

        do {
            try context.save()
            print("Save Success")
            print("id: \(data.id), memo: \(data.memo)")
        } catch {
            print("Save Error")
        }
    }
    
    func load() -> [ImageCoreDataModel]? {
        guard let context = context else { return nil }
        var dataArray = [ImageCoreDataModel]()
        let fetchRequest = NSFetchRequest<ImageCoreData>(entityName: entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                let imageCoreData = ImageCoreDataModel(id: result.id ?? "", memo: result.memo ?? "", originalURL: result.originalURL ?? "", savedLocation: result.savedLocation ?? "")
                dataArray.append(imageCoreData)
            }
            return dataArray
        } catch {
            print("Could not retrieve")
        }
        
        return nil
              
    }
}
