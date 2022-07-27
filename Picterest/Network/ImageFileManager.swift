//
//  ImageFileManager.swift
//  Picterest
//
//

import Foundation
import UIKit

enum ImageFileManagerError: Error {
    case notDirectory
    case failToDelete
}

class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()

    func saveImageToLocal(image: UIImage, name: String) {
        guard let data = image.pngData() else { return }
        if let directory: NSURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) as NSURL {
            do {
                guard let imageURL = directory.appendingPathComponent(name) else { return }
                try data.write(to: imageURL)
            } catch {
                print(ImageFileManagerError.notDirectory)
            }
            print(directory)
        }
    }
    
    func deleteImageFromLocal(named: String) {
        guard let directory = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) as NSURL else { return }
        do {
            if let documentPath = directory.path {
                let fileNames = try FileManager.default.contentsOfDirectory(atPath: documentPath)
                for fileName in fileNames {
                    if fileName == named {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try FileManager.default.removeItem(atPath: filePathName)
                    }
                }
            }
        } catch {
            print(ImageFileManagerError.failToDelete)
        }
    }
}
