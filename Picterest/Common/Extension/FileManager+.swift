//
//  FileManager+.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import Foundation

extension FileManager {
    private static var folderName: String { "SavedPhotos" }
    private static var folderURL: URL? {
        Self.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(folderName)
    }
    
    static func save(data: Data?, fileName: String) -> String? {
        guard let folderURL = folderURL else { return nil }
        
        if !Self.default.fileExists(atPath: folderURL.path) {
            do {
                try Self.default.createDirectory(
                    at: folderURL,
                    withIntermediateDirectories: true
                )
            } catch {
                return nil
            }
        }
        
        let writeURL = folderURL.appendingPathComponent(fileName + ".png")
        
        do {
            try data?.write(to: writeURL)
        } catch {
            return nil
        }
        
        return writeURL.path
    }
    
    static func remove(fileName: String) {
        guard let folderURL = folderURL else { return }
        
        let writeURL = folderURL.appendingPathComponent(fileName + ".png")
        
        do {
            try Self.default.removeItem(at: writeURL)
        } catch {
            return
        }
    }
    
    static func fetch(fileName: String) -> Data? {
        guard let folderURL = folderURL else { return nil }
        
        let writeURL = folderURL.appendingPathComponent(fileName + ".png")
        let data = Self.default.contents(atPath: writeURL.path)
        
        return data
    }
}
