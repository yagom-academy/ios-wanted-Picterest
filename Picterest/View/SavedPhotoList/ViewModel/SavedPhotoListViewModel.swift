//
//  SavedPhotoListViewModel.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//

import UIKit
import Combine

class SavedPhotoListViewModel {
    
    @Published var savedPhotos : [String] = []
    
    func getSavedPhotoListFromFilemanager() {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let directoryURL = directory.appendingPathComponent("images")
        print(directoryURL)
        do {
            var temp = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            if temp.contains(".DS_Store") {
                temp.remove(at: temp.firstIndex(of: ".DS_Store") ?? -1)
            }
            savedPhotos = temp
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSavedPhotoFromFilemanager(_ name : String) -> UIImage? {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let directoryURL = directory.appendingPathComponent("images")
        let imageURL = URL(fileURLWithPath: directoryURL.absoluteString).appendingPathComponent(name).path
        let image = UIImage(contentsOfFile: imageURL)
        
        return image
    }
    
    func makeImage(_ url : String) -> UIImage? {
        let cacheKey = NSString(string : url)
        if let cachedImage = CacheManager.shared.object(forKey: cacheKey) {
            return cachedImage
        } else {
            guard let imageUrl = URL(string: url) else {return nil}
            guard let imageData = try? Data(contentsOf: imageUrl) else {return nil}
            guard let image = UIImage(data: imageData) else {return nil}
            CacheManager.shared.setObject(image, forKey: cacheKey)
            return image
        }
    }
    
    func deleteImageFromFilemanager(_ name : String) {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let directoryURL = directory.appendingPathComponent("images")
        let imagePathURL = directoryURL.appendingPathComponent("\(name).jpg")
        do {
            try fileManager.removeItem(at: imagePathURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
