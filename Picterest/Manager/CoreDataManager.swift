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
    
    func save(
        id: String,
        imagePath: String,
        imageURL: String,
        memo: String
    ) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(
                forEntityName: "PhotoEntity",
                in: context
            ) else { return }
            
            let newValue = NSManagedObject(entity: entityDescription,
                                           insertInto: context)
             
            newValue.setValue(id, forKey: "id")
            newValue.setValue(imagePath, forKey: "imagePath")
            newValue.setValue(imageURL, forKey: "imageURL")
            newValue.setValue(memo, forKey: "memo")
            
            do {
                try context.save()
                print("saved id: \(id)")
                print("saved imagePath: \(imagePath)")
                print("saved imageURL: \(imageURL)")
                print("saved memo: \(memo)")
            } catch {
                print("saving error")
            }
        }
    }
    
    func retrieveValues() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let id = result.id,
                       let imagePath = result.imagePath,
                       let imageURL = result.imageURL,
                       let memo = result.memo {
                        print("id:\(id)")
                        print("imagePath:\(imagePath)")
                        print("imageURL:\(imageURL)")
                        print("memo:\(memo)")
                    }
                }
            } catch {
                print("Could not retrieve")
            }
            
        }
    }
}
