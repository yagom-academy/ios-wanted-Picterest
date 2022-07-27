//
//  StorageManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import UIKit
import Combine

final class StorageManager {
    
    // MARK: - Properties
    private let fileManager = FileManager.default
    private lazy var defaultDocumentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var directoryPath: URL?
    let saveSuccess = PassthroughSubject<URL, Never>()
    let deleteSuccess = PassthroughSubject<Void, Never>()
    
    init() {
        createDirectory()
    }
    
    // MARK: - Method
    private func createDirectory() {
        let directoryPath: URL = defaultDocumentPath.appendingPathComponent("starImage")
        print(directoryPath)
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            print(String(describing: error))
        }
        self.directoryPath = directoryPath
    }
    
    static func getImage(id: String) -> UIImage? {
        
        let fileManager = FileManager.default
        lazy var defaultDocumentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryPath: URL = defaultDocumentPath.appendingPathComponent("starImage")
        
        let imagePath = directoryPath.appendingPathComponent("\(id).png")
        
        if let image = ImageCacheManager.shared.getImage(imagePath.absoluteString) {
            return image
        }
        
        do {
            let imageData = try Data(contentsOf: imagePath)
            guard let image = UIImage(data: imageData) else { return nil }
            ImageCacheManager.shared.storeImage(imagePath.absoluteString, image: image)
            return image
        } catch let error {
            print(String(describing: error))
            return nil
        }
    }
    
    func saveImage(image: UIImage, id: String) {
        guard let data = uiImageToPngData(image),
              let imagePath = directoryPath?.appendingPathComponent("\(id).png") else { return }
        do {
            try data.write(to: imagePath)
            saveSuccess.send(imagePath)
        } catch let error {
            print(String(describing: error))
        }
    }
    
    func deleteImage(id: String) {
        guard let imagePath = directoryPath?.appendingPathComponent("\(id).png") else { return }
        do {
            try fileManager.removeItem(at: imagePath)
            deleteSuccess.send()
        } catch let error {
            print(String(describing: error))
        }
    }
    
    private func uiImageToPngData(_ image: UIImage) -> Data? {
        return image.pngData()
    }
}
