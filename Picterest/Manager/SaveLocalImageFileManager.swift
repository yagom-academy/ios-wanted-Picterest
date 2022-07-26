//
//  SaveImageFileManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation

class SaveLocalImageFileManager {
    static let shared: SaveLocalImageFileManager = SaveLocalImageFileManager()
    
    let defaultImageFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func saveLocalImage(imageId: String,completion: @escaping()->Void){
        let imageFilePath = defaultImageFilePath?.appendingPathComponent(imageId)
    }
}
