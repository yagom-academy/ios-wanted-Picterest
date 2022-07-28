//
//  CoreDataManager.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var images : [NSManagedObject] = []
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    func saveData(_ id : String, _ memo : String, _ url : String, _ path : String, _ width : Int32, _ height : Int32) {
        guard let context = self.context else {return}
        guard let entity = NSEntityDescription.entity(forEntityName: "Picterest", in: context) else {return}
        guard let image = NSManagedObject(entity: entity, insertInto: context) as? Picterest else {return}
        image.id = id
        image.memo = memo
        image.url = url
        image.path = path
        image.width = width
        image.height = height
        
        do {
            try self.context?.save()
            images.append(image)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getData() {
        guard let context = context else {return}
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Picterest")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            if self.images.isEmpty == true {
                self.images = result
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(_ object : NSManagedObject) {
        guard let context = context else {return}
        context.delete(object)
        images.remove(at: images.firstIndex(of: object) ?? -1)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Picterest")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context?.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
