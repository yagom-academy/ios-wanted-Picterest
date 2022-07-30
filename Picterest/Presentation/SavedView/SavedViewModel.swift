//
//  SavedImageViewModel.swift
//  Picterest
//
//  Created by oyat on 2022/07/30.
//

import Foundation

class SavedViewModel {
    
    private var saveDatas: [CoreDataInfo] = []
    
    var saveDataCount:Int {
        return saveDatas.count
    }
    
    func saveData(at index: Int) -> CoreDataInfo? {
        return saveDatas[safe: index]
    }
    
    func updateSaveData(completion: @escaping () -> ()) {
        let coreDataInfo = CoreDataManager.shared.getImageInfos()
        self.saveDatas = coreDataInfo
    }
}
