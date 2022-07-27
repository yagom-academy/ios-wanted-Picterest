//
//  ImageFileManager.swift
//  Picterest
//
//  Created by hayeon on 2022/07/27.
//

import Foundation
import UIKit

final class ImageFileManager {
    
    private let fileManager = FileManager.default
    private let directoryName = "Images"

    func saveImageToDevice(fileName: String, _ image: UIImage?) {
        guard let image = image else {
            return
        }
                
        let imageFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent(fileName)
        print("url: \(imageFileURL)")
        let imageData = image.pngData()
        
        do {
            try imageData?.write(to: imageFileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
