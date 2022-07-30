//
//  CoreData.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/30.
//

import Foundation
import CoreData

protocol CoreDataProtocol {
    func saveDataToCoreData(_ id : String, _ memo : String, _ url : String, _ path : String, _ width : Int32, _ height : Int32)
    func getDataFromCoreData()
    func deleteDataInCoreData(_ object : NSManagedObject)
}
