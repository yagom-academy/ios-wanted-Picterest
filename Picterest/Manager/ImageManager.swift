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
    
    func getDirectoryURL() -> URL? {
        guard let documentURL = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return nil }
        
        let directoryURL = documentURL.appendingPathComponent("Photo")
        
        return directoryURL
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
    
//    func loadImageFromAlbum(folderName: String) -> [String] {
//
////        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
////        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
////         "/Users/bh/Library/Developer/CoreSimulator/Devices/B3D368A7-7088-46DA-BE24-221DBCD20A48/data/Containers/Data/Application/332743D0-6BB3-4767-8905-9DDF462742C2/Documents"
//
//// file:///Users/bh/Library/Developer/CoreSimulator/Devices/B3D368A7-7088-46DA-BE24-221DBCD20A48/data/Containers/Data/Application/B17065C3-99D6-4EE2-99A7-986C2B20153B/Documents/Photo/
////        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//
////        let paths = try? fileManager.contentsOfDirectory(atPath: "Photo")
//
//        let paths = getDirectoryURL()
//        let test = try! fileManager.contentsOfDirectory(atPath: paths)
//        print("paths:\(test)")
//
////        var theitems: [String] = []
////        if let dirPath = paths.first {
////
////
////            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(folderName)
////            do {
////                theitems = try FileManager.default.contentsOfDirectory(atPath: imageURL.path)
////                return theitems
////            } catch let error {
////                print(error.localizedDescription)
////                return theitems
////            }
////        }
//        return [""]
//    }
    
}
