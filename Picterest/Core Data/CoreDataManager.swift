//
//  File.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import Foundation

import CoreData

class CoreDataManager {
    
   static let shared = CoreDataManager()
   private init() { }
   var container: NSPersistentContainer?
   var mainContext: NSManagedObjectContext {
    guard let context = container?.viewContext else{
      fatalError("Not Implemented")
    }
    return context
   }

    func setup(modelName: String){
        container = NSPersistentContainer(name: modelName)
        container?.loadPersistentStores(completionHandler: {(desc, error) in
            if let error = error{
                fatalError(error.localizedDescription)
            }
        })
    }
    func saveMainContext() {
        mainContext.perform {
            if self.mainContext.hasChanges{
                do{
                    try self.mainContext.save()
                }catch{
                    print(error)
                }
            }
        }
   }
}

extension CoreDataManager {
    func createItem(name: String, path: String, url: String, memo: String , completion: (() -> ())? = nil){
        mainContext.perform{
            let newItem = Entity(context: self.mainContext)
            newItem.id = name
            newItem.path = path
            newItem.url = url
            newItem.memo = memo
            self.saveMainContext()
            completion?()
        }
    }
    
    func fatchItem(predicate: NSPredicate? = nil) -> [Entity]{
        var list = [Entity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<Entity> = Entity.fetchRequest()
            request.predicate = predicate
            do{
                list = try mainContext.fetch(request)
            }catch{
                print(error)
            }
        }
        return list
    }
    
    func delete(entity: Entity){
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}
