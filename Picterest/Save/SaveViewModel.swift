//
//  SaveViewModel.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

class SaveViewModel {
    
    func deleteSavePhoto(_ savePhotoData: SavePhoto) {
        guard let location = savePhotoData.location else { return }
        PhotoFileManager.shared.deletePhotoFile(location)
        CoreDataManager.shared.deleteSavePhoto(savePhotoData)
    }
}
