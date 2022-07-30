//
//  SavedPhotoListViewModel.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//

import UIKit
import Combine
import CoreData

class SavedPhotoListViewModel {
    
    @Published var savedPhotos : [String] = []
    
    // MARK: Util
    
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
}
    // MARK: FileManager
    
extension SavedPhotoListViewModel : FileManagerProtocol {
    func saveImageToFilemanager(_ image: UIImage, _ name: String) -> String {return ""}
    
    func getSavedPhotoListFromFilemanager() {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let directoryURL = directory.appendingPathComponent("images")
        do {
            let temp = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
            let sortedTemp = temp.sorted(by: {
                if let date1 = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate,
                           let date2 = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate {
                            return date1 < date2
                }
                return false
            })
            savedPhotos = sortedTemp.map { $0.absoluteString }
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
    
    func deleteImageFromFilemanager(_ name : String) {
        let fileManager = FileManager.default
        
        guard let directory : URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let directoryURL = directory.appendingPathComponent("images")
        let imagePathURL = directoryURL.appendingPathComponent("\(name)")
        do {
            try fileManager.removeItem(at: imagePathURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
    // MARK: Core Data
    
extension SavedPhotoListViewModel : CoreDataProtocol {
    func saveDataToCoreData(_ id: String, _ memo: String, _ url: String, _ path: String, _ width: Int32, _ height: Int32) {}
    
    func getDataFromCoreData() {
        CoreDataManager.shared.getData()
    }
    
    func deleteDataInCoreData(_ object: NSManagedObject) {
        CoreDataManager.shared.deleteData(object)
    }
}
