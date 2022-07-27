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
    
    static func getImage(starImage: StarImage, completion: @escaping (UIImage?) -> Void) {
        
        let fileManager = FileManager.default
        lazy var defaultDocumentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let directoryPath: URL = defaultDocumentPath.appendingPathComponent("starImage")
        
        let imagePath = directoryPath.appendingPathComponent("\(starImage.id ?? "").png")
        
        if let image = ImageCacheManager.shared.getImage(imagePath.absoluteString) {
            completion(image)
            return
        }
        
        do {
            let imageData = try Data(contentsOf: imagePath)
            guard let image = UIImage(data: imageData) else { return }
            ImageCacheManager.shared.storeImage(imagePath.absoluteString, image: image)
            completion(image)
            return
        } catch {
//            print(String(describing: error))
            NetworkManager.fetchImage(urlString: starImage.networkURL ?? "") { image in
                guard let image = image else {
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
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
