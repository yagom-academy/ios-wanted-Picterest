//
//  FileManager.swift
//  Picterest
//
//  Created by BH on 2022/07/29.
//

import Foundation
import UIKit.UIImage

class ImageManager {
    
    // MARK: - Properties
    
    static let shared = ImageManager()
    private init() { }
    
    var fileManager = FileManager.default
    
}

// MARK: - Methods extension

extension ImageManager {
    
    func getDirectoryURL() -> URL? {
        guard let documentURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return nil }
        let directoryURL = documentURL.appendingPathComponent("Photo")
        
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print("Failed create directory")
            }
        }
        
        return directoryURL
    }
    
    func getImagePath(id: String) -> String {
        guard let directoryURL = getDirectoryURL() else {
            print("directoryURL을 찾을 수 없음.")
            return "" }
        let imagePath = directoryURL.appendingPathComponent(id)
        
        return imagePath.absoluteString
    }
    
    func saveImage(id: String, image: UIImage) -> Bool {
        guard let directoryURL = getDirectoryURL() else { return false }
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return false
        }
        do {
            try imageData.write(to: directoryURL.appendingPathComponent(id))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func loadImage(id: String) -> UIImage? {
        guard let directoryURL = getDirectoryURL() else { return nil }
        let imageURL = directoryURL.appendingPathComponent(id)
        
        do {
            guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
            return UIImage(data: imageData)
        }
    }
    
    func deleteImage(id: String) {
        guard let directoryURL = getDirectoryURL() else { return }
        let imageURL = directoryURL.appendingPathComponent(id)
        
        do {
            try? fileManager.removeItem(at: imageURL)
        }
    }
    
}
