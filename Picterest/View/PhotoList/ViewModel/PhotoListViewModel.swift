//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit
import Combine

class PhotoListViewModel : ObservableObject {
    
    @Published var photoList : [Photo]?
    var pageNumber = 1
    var perPage = 15
    let photoManager = PhotoManager()

    func getDataFromServer() {
        photoManager.getData(perPage, pageNumber) { [weak self] photoList in
            self?.imageCaching(photoList)
            if self?.photoList == nil {
                self?.photoList = photoList
            } else {
                self?.photoList?.append(contentsOf: photoList)
            }
        }
        pageNumber += 1
    }
    
    func imageCaching(_ data : [Photo]) {
        for value in data {
            makeImage(value.urls.small)
        }
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
    
    func saveImageToFilemanager(_ image : UIImage, _ name : String) {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let directoryURL = directory.appendingPathComponent("images")
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        let imagePathURL = directoryURL.appendingPathComponent("\(name).jpg")
        let data = image.jpegData(compressionQuality: 1.0)
        do {
            try data?.write(to: imagePathURL)
        } catch {
            print(error.localizedDescription)
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
    
    func saveDataToCoreData() {
        
    }
}
