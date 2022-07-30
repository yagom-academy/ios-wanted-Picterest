//
//  SaveImageFileManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation

class LocalImageFileManager {
    static let shared: LocalImageFileManager = LocalImageFileManager()
    
    let defaultImageFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func saveLocalImage(imageViewModel: ImageViewModel,completion: @escaping(String)->Void) {
        guard let imageFilePath = defaultImageFilePath?.appendingPathComponent("\(imageViewModel.id).png") else { return }
        NetworkManager.shared.fetchImage(url: imageViewModel.url) { image in
            let imageData = image.pngData()
            do {
                try imageData?.write(to: imageFilePath)
                completion(imageFilePath.path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteLocalImage(id: String, completion: @escaping () -> Void) {
        guard let imageFilePath = defaultImageFilePath?.appendingPathComponent("\(id).png") else { return }
        do {
            try FileManager.default.removeItem(at: imageFilePath)
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkImageInLocal(id: String) -> Bool {
        if let imageFilePath = defaultImageFilePath?.appendingPathComponent("\(id).png") {
            if FileManager.default.fileExists(atPath: imageFilePath.path) {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
