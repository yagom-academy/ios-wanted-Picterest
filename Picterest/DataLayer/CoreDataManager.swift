//
//  CoreDataManager.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation
import CoreData

class CoreDataManager {
  static var shared: CoreDataManager = CoreDataManager()
  
  //MARK: Persistent container: Core Data Stack을 나타내는 모든 객체를 포함한다.
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreData")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  var imageData: NSEntityDescription? {
    return  NSEntityDescription.entity(forEntityName: "ImageData", in: context)
  }
  
  func fetchImages() -> [ImageData]? {
    do {
      let data = try context.fetch(ImageData.fetchRequest()) as! [ImageData]
      print("총 \(data.count) 개의 이미지가 코어데이터에 저장되어 있습니다")
      print(data.forEach({ imageData in
        print(imageData.memo)
        print(imageData.storedDirectory)
      }))
      return data
    }catch{
      print(error.localizedDescription)
    }
    return nil
  }
  
  func insert(_ model: ImageEntity) {
    print("Inserting \(model.id)...")
    if let entity = imageData {
      let managedObject = NSManagedObject(entity: entity, insertInto: context)
      managedObject.setValue(model.id, forKey: "id")
      managedObject.setValue(model.memo, forKey: "memo")
      managedObject.setValue(model.imageURL, forKey: "imageURL")
      managedObject.setValue(model.storedDirectory, forKey: "storedDirectory")
      save()
    }
  }
  
  
  func delete(_ model: ImageEntity){
    print("Deleting \(model.id)...")
    guard let fetchResults = fetchImages(),
          let targetModel = fetchResults.filter({$0.id == model.id}).first
    else {return}
    context.delete(targetModel)
    save()
  }
  
  func deleteAll(){
    guard let fetchResults = fetchImages()else {return}
    print("Deleting All data in coreData ...")
    for item in fetchResults {
      context.delete(item)
    }
    save()
  }
  
  
  private func save() {
    do {
      try context.save()
    }catch{
      print(error.localizedDescription)
    }
  }
  
}
