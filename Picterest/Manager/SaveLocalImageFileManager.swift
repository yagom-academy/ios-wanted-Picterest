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
    
    func saveLocalImage(imageViewModel: ImageViewModel,completion: @escaping(String)->Void){
        guard let imageFilePath = defaultImageFilePath?.appendingPathComponent("\(imageViewModel.id).png") else { return }
        NetworkManager.shared.fetchImage(url: imageViewModel.url) { image in
            let imageData = image.pngData()
            do {
                try imageData?.write(to: imageFilePath)
                completion(imageFilePath.path)
                print(imageFilePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
