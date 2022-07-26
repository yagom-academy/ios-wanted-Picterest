//
//  StorageManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import UIKit

final class StorageManager {
    private let fileManager = FileManager.default
    private lazy var defaultDocumentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var directoryPath: URL?
    
    init() {
        createDirectory()
    }
    
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
    
    func saveImage(image: UIImage, id: String) {
        guard let data = uiImageToPngData(image),
              let imagePath = directoryPath?.appendingPathComponent("\(id).png") else { return }
        do {
            try data.write(to: imagePath)
        } catch let error {
            print(String(describing: error))
        }
    }
    
    func deleteImage(id: String) {
        guard let imagePath = directoryPath?.appendingPathComponent("\(id).png") else { return }
        do {
            try fileManager.removeItem(at: imagePath)
        } catch let error {
            print(String(describing: error))
        }
    }
    
    private func uiImageToPngData(_ image: UIImage) -> Data? {
        return image.pngData()
    }
}
