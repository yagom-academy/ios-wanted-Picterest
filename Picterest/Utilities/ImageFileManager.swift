//
//  ImageFileManager.swift
//  Picterest
//
//  Created by hayeon on 2022/07/27.
//

import Foundation
import UIKit

final class ImageFileManager {
    
    static let shared = ImageFileManager()
    private init() { }
    
    private let fileManager = FileManager.default
    
    func save(_ fileName: NSString, _ image: UIImage?) -> String? {
        guard let image = image else {
            return nil
        }
                
        let imageFileURL = makeFileURL(using: fileName)
        let imageData = image.pngData()
        
        do {
            try imageData?.write(to: imageFileURL)
        } catch {
            print(error.localizedDescription)
            print("31")
        }
        print("path: \(imageFileURL.path)")
        return imageFileURL.path
    }
    
    func load(_ fileName: NSString) -> Data? {
        let imageFileURL = makeFileURL(using: fileName)
        
        do {
            let imageData = try Data(contentsOf: imageFileURL)
            return imageData
        } catch {
            print(error.localizedDescription)
            print("45")
        }
        
        return nil
    }
    
    func removeItem(at savedLocation: String) {
        do {
            try fileManager.removeItem(atPath: savedLocation)
            print("file remove well")
        } catch {
            print(error.localizedDescription)
            print("hi")
        }
    }

    func fileExists(_ fileName: NSString) -> Bool {
        let imageFileURL = makeFileURL(using: fileName)
        return fileManager.fileExists(atPath: imageFileURL.path)
    }
   
}

extension ImageFileManager {
    private func makeFileURL(using fileName: NSString) -> URL {
        let fileURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName as String)
        return fileURL
    }
    
}
