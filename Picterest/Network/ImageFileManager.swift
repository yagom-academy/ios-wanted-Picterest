//
//  ImageFileManager.swift
//  Picterest
//
//

import UIKit

enum ImageFileManagerError: Error {
    case notDirectory
    case failToDelete
}

final class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()

    func saveImageToLocal(image: UIImage, name: String) -> String? {
        guard let data = image.pngData() else { return nil }
        if let directory: NSURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) as NSURL {
            do {
                guard let imageURL = directory.appendingPathComponent(name) else { return nil }
                try data.write(to: imageURL)
                return imageURL.path
            } catch {
                print(ImageFileManagerError.notDirectory)
            }
        }
        return nil
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
