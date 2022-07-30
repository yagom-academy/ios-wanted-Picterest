//
//  FileManager.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/26.
//

import UIKit

enum FileError: String {
    case canNotDeleteFile = "파일을 지울 수 없습니다."
    case fileDoesNotExit = "경로에 해당 파일이 존재하지 않습니다."
    case canNotCreateDic = "폴더를 생성할 수 없습니다."
}

protocol FileStatusReceivable: AnyObject {
    func fileManager(_ fileManager: FileManager, error: FileError, desc: Error?)
}

final class PicterestFileManager {
    
    static let shared = PicterestFileManager()
    
    weak var delegate: FileStatusReceivable?
    
    private let fileManager = FileManager.default
    private let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Picterest_Photos")
    
    init() {
        initializeFileFolder()
    }
    
    private func initializeFileFolder() {
        guard !fileManager.fileExists(atPath: directoryPath.path) else { return }
        createDic()
    }
    
    private func createDic() {
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch let error {
            if let delegate = delegate {
                delegate.fileManager(fileManager, error: .canNotCreateDic, desc: error)
            }
        }
    }
    
    func getPictureLocaUrl(fileName: String) -> URL{
        return directoryPath.appendingPathComponent(fileName)
    }
    
    func savePicture(fileName: String, image: UIImage) -> URL {
        let fileUrl = directoryPath.appendingPathComponent(fileName)
        if let data = image.pngData() {
            do {
                try data.write(to: fileUrl)
            } catch {
                print(error)
            }
        }
        return fileUrl
    }
   
    func deletePicture(fileName: String) {
        let filePath = directoryPath.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.removeItem(at: filePath)
            } catch let error {
                if let delegate = delegate {
                    delegate.fileManager(fileManager, error: FileError.canNotDeleteFile, desc: error)
                }
            }
        } else {
            if let delegate = delegate {
                delegate.fileManager(fileManager, error: FileError.fileDoesNotExit, desc: nil)
            }
        }
    }
    
}
