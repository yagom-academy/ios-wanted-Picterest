//
//  CoreDataStorage.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/28.
//

import CoreData

class ImageDataCoreDataStorage: CoreDataStorage{
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T>(request: NSFetchRequest<T>, completion: @escaping ((Result<[T], Error>) -> Void)) where T : NSManagedObject {
        do {
            let fetchResult = try self.context.fetch(request)
            completion(.success(fetchResult))
        } catch {
            print(error.localizedDescription)
            completion(.failure(CoreDataStorageError.readError(error)))
        }
    }
    
    func insertImageinfo(imageInfo: ImageInfo, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        let entity = NSEntityDescription.entity(forEntityName: "ImageData", in: self.context)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(imageInfo.id, forKey: "id")
            managedObject.setValue(imageInfo.memo, forKey: "memo")
            managedObject.setValue(imageInfo.orginUrl, forKey: "orginUrl")
            managedObject.setValue(imageInfo.locationUrl, forKey: "locationUrl")
            managedObject.setValue(imageInfo.ratio, forKey: "ratio")
            do {
                try self.context.save()
                completion(.success(true))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        } else {
            completion(.success(false))
        }
    }
    
    func delete(object: NSManagedObject, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        self.context.delete(object)
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(CoreDataStorageError.deleteError(error)))
        }
    }
}
