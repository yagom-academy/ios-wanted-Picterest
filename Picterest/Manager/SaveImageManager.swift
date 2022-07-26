//
//  SaveImageManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation

class SaveImageManager {
    let coredataManager = CoredataManager()
    let saveLocalImageFileManager = SaveLocalImageFileManager()
    
    func saveImageAndInfo(imageViewModel: ImageViewModel, memo: String){
        saveLocalImageFileManager.saveLocalImage(imageViewModel: imageViewModel) { imageFilePath in
            self.coredataManager.setImageInfo(imageViewModel, memo: memo, saveLocation: imageFilePath)
        }
    }
}
