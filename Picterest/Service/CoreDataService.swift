//
//  CoreDataService.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/28.
//

import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    lazy var persistentContrainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error) \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContrainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContrainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(
        request: NSFetchRequest<T> = NSFetchRequest(entityName: "SavedModel")
    ) -> [savedModel] {
        //TODO: - Sort 메서드 추가하기
        do {
            var values: [savedModel] = []
            let result = try context.fetch(request) as? [SavedModel]
            result?.forEach {
                let value = savedModel(id: $0.id,
                                       memo: $0.memo,
                                       file: $0.fileURL,
                                       raw: $0.rawURL)
                values.append(value)
            }
            return values
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchManagement<T: NSManagedObject>(
        request: NSFetchRequest<T> = NSFetchRequest(entityName: "SavedModel")
    ) -> [T] {
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Error in fetch Management \(error)")
            return []
        }
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func deleteAll() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedModel")
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}
