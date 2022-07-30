//
//  DataManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}
    
    func save(data: Image, memo: String) {
        LocalFileManager.shared.save(data: data)
        let localPath = LocalFileManager.shared.localPath
        CoreDataManager.shared.saveData(data: data, memo: memo, localPath: localPath)
    }
    
    func delete(id: String) {
        LocalFileManager.shared.delete(data: id)
        CoreDataManager.shared.deleteData(id: id)
    }
}
