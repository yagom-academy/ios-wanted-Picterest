//
//  CoreDataStorage.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/29.
//

import CoreData

protocol CoreDataStorage {
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>,completion: @escaping ((Result<[T],Error>) -> Void))
    func insertImageinfo(imageInfo: ImageInfo, completion: @escaping ((Result<Bool,Error>) -> Void))
    func delete(object: NSManagedObject, completion: @escaping ((Result<Bool,Error>) -> Void))
}
