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
    
    func fetchCoreData() -> [Picterest] {
        let fetchRequest: NSFetchRequest<Picterest> = Picterest.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        do {
            self.coreData = try context.fetch(fetchRequest)
            return coreData
        } catch {
            print(error)
            return []
        }
    }
        
    func saveCoreData(id: String, memo: String, url: String, location: String) {
        let context = appDelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Picterest", in: context) else { return }
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? Picterest else { return }
        
        object.id = id
        object.url = url
        object.location = location
        object.memo = memo
        
        appDelegate.saveContext()
    }
    
    func deleteCoreData(ID: String) {
        let context = appDelegate.persistentContainer.viewContext
        let object = coreData.first {
            $0.id == ID
        }
        guard let object = object else { return }
        context.delete(object)
        appDelegate.saveContext()
    }
}
