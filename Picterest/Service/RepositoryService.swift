//
//  RepositoryService.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/27.
//

import Foundation

protocol RepositoryAble {
    func fetchData(_ key: String) -> Data?
    func uploadData(key: String, data: Data) -> Bool
}

class CacheService: RepositoryAble {
    static let shared = CacheService()
    
    private let cache = NSCache<NSString,NSData>()
    
    func fetchData(_ key: String) -> Data? {
        guard let data = cache.object(forKey: key as NSString) else {
            return nil
        }
        return Data(referencing: data)
    }
    
    @discardableResult
    func uploadData(key: String, data: Data) -> Bool {
        cache.setObject(NSData(data: data), forKey: key as NSString)
        return false
    }
}

class DownLoadManager: RepositoryAble {
    private var folderURL: URL? {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(name)
    }
    private var name: String = "Picterest"
    
    init() {
        createFolder()
    }
    
    func fetchData(_ key: String) -> Data? {
        guard let writeURL = folderURL?.appendingPathComponent(key) else {
            return nil
        }
        return FileManager.default.contents(atPath: writeURL.path)
    }
    
    func uploadData(key: String, data: Data) -> Bool {
        guard let writeURL = folderURL?.appendingPathComponent(key) else {
            return false
        }
        try? data.write(to: writeURL)
        return true
    }
    
    func removeData(_ key: String) -> Bool {
        guard let writeURL = folderURL?.appendingPathComponent(key) else {
            return false
        }
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
