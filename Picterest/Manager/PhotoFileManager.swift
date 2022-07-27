//
//  PhotoFileManager.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/27.
//

import Foundation

class PhotoFileManager {
    
    private let fileManager = FileManager.default
    private let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var directoryPath = documentPath.appendingPathComponent("SavePhotoFolder")
    
//    func createPhotoFile() {
//        try fileManager.createDirectory(at: directoryPath.path, withIntermediateDirectories: false, attributes: nil)
//    }
    
    func getPhotoFilePath(_ fileName: String) -> URL {
        return documentPath.appendingPathComponent(fileName)
    }
}
