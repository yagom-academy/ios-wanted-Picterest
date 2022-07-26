//
//  CoreDataManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    
    // MARK: - Properties
    private let entityName = "StarImage"
    private let persistentContainer: NSPersistentContainer
    let getAllStarImageSuccess = PassthroughSubject<[StarImage], Never>()
    
    init() {
        persistentContainer = NSPersistentContainer(name: entityName)
        persistentContainer.loadPersistentStores { _, error in
            if let error =  error {
                print(String(describing: error))
            }
        }
    }
    
    // MARK: - Method
    func getAllStarImages() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        guard let starImages = try? persistentContainer.viewContext.fetch(fetchRequest) as? [StarImage] else {
            return
        }
        
        getAllStarImageSuccess.send(starImages)
    }
    
    func saveStarImages(entity: StarImageEntity) {
        let starImage = StarImage(context: persistentContainer.viewContext)
        starImage.id = entity.id
        starImage.memo = entity.memo
        starImage.networkURL = entity.networkURL
        starImage.storageURL = entity.storageURL
        
        do {
            try persistentContainer.viewContext.save()
            getAllStarImages()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func deleteStarImage(starImage: StarImage) {
        persistentContainer.viewContext.delete(starImage)
        
        do {
            try persistentContainer.viewContext.save()
            getAllStarImages()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}
