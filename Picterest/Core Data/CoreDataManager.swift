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
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("ERROR: \(error)")
            }
        })
        return container
    }()
   var mainContext: NSManagedObjectContext {
    return container.viewContext
   }

    func setup(modelName: String){
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: {(desc, error) in
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
    func createItem(name: String, path: String, url: String, memo: String, height: Int64, width: Int64 , completion: @escaping () -> ()){
        mainContext.perform{
            let newItem = Entity(context: self.mainContext)
            newItem.id = name
            newItem.path = path
            newItem.url = url
            newItem.memo = memo
            newItem.height = height
            newItem.width = width
            self.saveMainContext()
            completion()
        }
    }
    
    func fatchItem(completion: @escaping ([Entity]) -> ()){
        var list = [Entity]()
        
        mainContext.performAndWait {
            let request: NSFetchRequest<Entity> = Entity.fetchRequest()
            request.returnsObjectsAsFaults = false 
            do{
                list = try mainContext.fetch(request)
            }catch{
                print("ERROR: ",error)
            }
        }
        completion(list)
    }
    
    func delete(entity: Entity){
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}
