//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit
import Combine
import CoreData

class PhotoListViewModel : ObservableObject {
    
    @Published var photoList : [Photo]?
    
    private var pageNumber = 1
    private var perPage = 15
    private let photoManager = PhotoManager()
    
    // MARK: Network (Server)
    
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
    
    // MARK: Caching
    
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
    
    func imageCaching(_ data : [Photo]) {
        for value in data {
            let cacheKey = NSString(string : value.urls.small)
            guard let imageUrl = URL(string: value.urls.small) else {return}
            guard let imageData = try? Data(contentsOf: imageUrl) else {return}
            guard let image = UIImage(data: imageData) else {return}
            CacheManager.shared.setObject(image, forKey: cacheKey)
        }
    }
    
    // MARK: Util
    
    func isSavedImage(_ name : String) -> Bool? {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let directoryURL = directory.appendingPathComponent("images")
        let imagePathURL = directoryURL.appendingPathComponent("\(name).jpg")
        if fileManager.fileExists(atPath: imagePathURL.path) {
            return true
        } else {
            return false
        }
    }
}

// MARK: FileManager

extension PhotoListViewModel : FileManagerProtocol {
    func saveImageToFilemanager(_ image: UIImage, _ name: String) -> String {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return ""}
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
            return directoryURL.path
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func deleteImageFromFilemanager(_ name: String) {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let directoryURL = directory.appendingPathComponent("images")
        let imagePathURL = directoryURL.appendingPathComponent(name)
        do {
            try fileManager.removeItem(at: imagePathURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSavedPhotoListFromFilemanager() {}
    
    func getSavedPhotoFromFilemanager(_ name: String) -> UIImage? {return nil}
    
}
// MARK: - Core Data

extension PhotoListViewModel : CoreDataProtocol {
    func saveDataToCoreData(_ id : String, _ memo : String, _ url : String, _ path : String, _ width : Int32, _ height : Int32) {
        CoreDataManager.shared.saveData(id, memo, url, path, width, height)
    }
    
    func getDataFromCoreData() {
        CoreDataManager.shared.getData()
    }
    
    func deleteDataInCoreData(_ object : NSManagedObject) {
        CoreDataManager.shared.deleteData(object)
    }
}
