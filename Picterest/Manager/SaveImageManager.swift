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
    
    func saveImageAndInfo(imageViewModel: ImageViewModel){
        saveLocalImageFileManager.saveLocalImage(imageViewModel: imageViewModel) {
            
        }
    }
    
}
