//
//  PhotoFileManager.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/27.
//

import Foundation

class PhotoFileManager {
    
    private let fileManager = FileManager.default
    private let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func getPhotoFilePath(_ fileName: String) -> URL {
        return directoryPath.appendingPathComponent(fileName)
    }
}
