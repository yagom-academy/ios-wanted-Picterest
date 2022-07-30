//
//  SavedViewModel.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import Foundation
import CoreData

final class SavedViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    
    func getNumberOfImages() -> Int {
        return coreDataManager.coreDataArray.count
    }
    
    func getImage(at index: Int) -> NSManagedObject? {
        if index < 0 || index >= coreDataManager.coreDataArray.count {
            return nil
        }
        return coreDataManager.coreDataArray[index]
    }
}
