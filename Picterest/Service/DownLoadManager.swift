//
//  FileManager.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/28.
//

import Foundation

class DownLoadManager: cacheAble {
    static let shared = DownLoadManager()
    var folderURL: URL? {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(name)
    }
    var name: String = "Picterest"
    
    init() {
        createFolder()
    }
    
    func fetchData(_ key: String) -> Data? {
        guard let writeURL = folderURL?.appendingPathComponent(key) else {
            return nil
        }
        return FileManager.default.contents(atPath: writeURL.path)
    }
    
    func uploadData(key: String, data: Data) {
        guard let writeURL = folderURL?.appendingPathComponent(key) else {
            return
        }
        try? data.write(to: writeURL)
    }
    
    func removeData(_ key: String) -> Bool {
        guard let writeURL = folderURL?.appendingPathComponent(key) else {
            return false
        }
        print(writeURL)
        try? FileManager.default.removeItem(at: writeURL)
        return true
    }
    
    private func createFolder() {
        guard let folderURL = folderURL else {
            return
        }

        if FileManager.default.fileExists(atPath: folderURL.path) {
            return
        }
        
        try? FileManager.default.createDirectory(
            at: folderURL,
            withIntermediateDirectories: true
        )
    }
}
