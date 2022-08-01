//
//  File.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import UIKit

class FileSaveManager {
    static let shared = FileSaveManager()
    
    func saveImage(image: UIImage, name: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            let path = directory.absoluteString! + name + ".png"
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
