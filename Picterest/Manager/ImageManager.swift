//
//  FileManager.swift
//  Picterest
//
//  Created by BH on 2022/07/29.
//

import Foundation
import UIKit.UIImage

class ImageManager {
    
    static let shared = ImageManager()
    private init() { }
    
    var fileManager = FileManager.default
    
    func saveImage(id: String, image: UIImage) -> Bool {
        
        guard let documentURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return false }
        let directoryURL = documentURL.appendingPathComponent("Photo")
        
        do {
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        } catch let error {
            print("directroy 생성실패:\(error.localizedDescription)")
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return false
        }

        do {
            try imageData.write(to: directoryURL.appendingPathComponent("\(id).jpeg"))
            print("저장완료:\(directoryURL)")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
