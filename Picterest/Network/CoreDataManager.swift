//
//  CoreDataManager.swift
//  Picterest
//
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coreData = [Picterest]()
    
    func fetchCoreData(completion: @escaping ([Picterest]) -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        context.performAndWait {
            let fetchRequest: NSFetchRequest<Picterest> = Picterest.fetchRequest()
            do {
                self.coreData = try context.fetch(fetchRequest)
                completion(coreData)
            } catch {
                print(error)
                return
            }
        }
    }
        
    func saveCoreData(id: String, memo: String, url: String, location: String, width: Double, height: Double) {
        let context = appDelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Picterest", in: context) else { return }
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? Picterest else { return }
        context.perform {
            object.id = id
            object.url = url
            object.location = location
            object.memo = memo
            object.width = width
            object.heigt = height
            self.appDelegate.saveContext()
        }
    }
    
    func deleteCoreData(ID: String) {
        let context = appDelegate.persistentContainer.viewContext
        context.performAndWait {
        let object = coreData.first {
            $0.id == ID
        }
        guard let object = object else { return }
        context.delete(object)
        appDelegate.saveContext()
        }
    }
}
