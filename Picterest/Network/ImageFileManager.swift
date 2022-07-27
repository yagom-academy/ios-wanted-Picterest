//
//  ImageFileManager.swift
//  Picterest
//
//

import Foundation
import UIKit

enum ImageFileManagerError: Error {
    case notDirectory
}

class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    
    func saveImage(image: UIImage, name: String) {
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
}
