//
//  CoreDataManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let entityName = "StarImage"
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: entityName)
        persistentContainer.loadPersistentStores { _, error in
            if let error =  error {
                print(String(describing: error))
            }
        }
    }
    
    func getAllStarImages() -> [StarImage] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        guard let starImages = try? persistentContainer.viewContext.fetch(fetchRequest) as? [StarImage] else {
            return []
        }
        return starImages
    }
    
    func saveStarImages(entity: StarImageEntity) {
        let starImage = StarImage(context: persistentContainer.viewContext)
        starImage.id = entity.id
        starImage.memo = entity.memo
        starImage.networkURL = entity.networkURL
        starImage.storageURL = entity.storageURL
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func deleteStarImage(starImage: StarImage) {
        persistentContainer.viewContext.delete(starImage)
    }
}
