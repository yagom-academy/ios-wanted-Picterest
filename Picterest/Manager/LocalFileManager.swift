//
//  LocalFileManager.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    private init() {}
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    var localPath: String {
        guard let local = documentURL else { return "" }
        return local.path
    }
    
    func checkFileExistInLocal(id: String) -> Bool {
        guard let imageURL = documentURL?.appendingPathComponent(id) else { return false }
        if FileManager.default.fileExists(atPath: imageURL.path) {
            return true
        }
        return false
    }
    
    func save(data: Image) {
        guard let imageURL = documentURL?.appendingPathComponent(data.id) else { return }
        NetworkManager.shared.fetchImage(url: data.urls.small) { image in
            do {
                let pngImage = image.pngData()
                try pngImage?.write(to: imageURL)
            } catch {
                debugPrint("이미지 저장 실패")
            }
        }
    }
    
    func delete(data id: String) {
        guard let imageURL = documentURL?.appendingPathComponent(id) else { return }
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
            } catch {
                debugPrint("이미지 삭제 실패")
            }
        }
    }
}
