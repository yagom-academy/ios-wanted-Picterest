//
//  DataManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    func save(data: ImageViewModel, memo: String) {
        LocalFileManager.shared.saveToLocal(data)
        let localPath = LocalFileManager.shared.localPath
        CoreDataManager.shared.saveData(data: data, memo: memo, localPath: localPath)
    }
    
    func delete(data: SavedImageViewModel) {
        LocalFileManager.shared.deleteFromLocal(id: data.id)
        CoreDataManager.shared.deleteData(id: data.id)
    }
}
