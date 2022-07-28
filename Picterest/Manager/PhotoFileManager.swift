//
//  PhotoFileManager.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/27.
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

class PhotoFileManager {
    
    weak var delegate: FileStatusReceivable?
    
    static let shared = PhotoFileManager()
    
    private let fileManager = FileManager.default
    private let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SavePhoto")
    
    init() {
        createDirectory()
    }
    
    func createDirectory() {
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createPhotoFile(_ image: UIImage, _ fileName: String) -> URL {
        let path = directoryPath.appendingPathComponent(fileName)

        if let data = image.jpegData(compressionQuality: 1) ?? image.pngData() {
            do {
                try data.write(to: path)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return path
    }
    
    func getPhotoFilePath(_ fileName: String) -> URL {
        return directoryPath.appendingPathComponent(fileName)
    }
    
    func deletePhotoFile(_ filePath: String) {
        guard let url = URL(string: filePath) else { return }
        
        do {
            try fileManager.removeItem(at: url)
        } catch let error {
            delegate?.fileManager(fileManager, error: FileError.canNotCreateDic, desc: error)
        }
    }
}
