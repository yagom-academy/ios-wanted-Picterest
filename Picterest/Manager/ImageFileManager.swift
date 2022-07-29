//
//  ImageFileManager.swift
//  Picterest
//
//  Created by oyat on 2022/07/28.
//

import Foundation
import UIKit

class ImageFileManager {
    static let shared = ImageFileManager()
    
    private init() {
        initFolder()
    }
    
    private let fileManager = FileManager.default
    private let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var picDownURL = documentURL.appendingPathComponent("PicDownFolder")
    
    func initFolder() {
        
        //사진다운받을 파일 "picDownFolder"가 없으면 가드문 그냥 통과후 createFolder 함수 실행
        guard !fileManager.fileExists(atPath: picDownURL.path) else { return }
        
        //없으면 picDownFolder 생성
        createFolder()
    }
    
    func createFolder() {
        do {
            try fileManager.createDirectory(at: picDownURL, withIntermediateDirectories: false)
        } catch {
            print(error)
        }
    }
    
    func saveImageUrl(imageUrl: String?, imageID: String, completion: @escaping (Result<String,Error>) -> ()) {
        guard let urlString = imageUrl else {
            return
        }
        
        let cachedImage = ImageCacheManager.shared.cachedImage(urlString: urlString)
        
        if cachedImage != nil  {
            guard let result = createFile(image: cachedImage, imageID: imageID) else {
                return
            }
            completion(.success(result))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return
            }
            ImageCacheManager.shared.setObject(image: image, urlString: urlString)
            guard let result = self?.createFile(image: image, imageID: imageID)else {
                return
            }
            completion(.success(result))
        }.resume()
        
    }
    
    func createFile(image: UIImage?, imageID: String) -> String? {
        
        guard let image = image else { return nil }
        let imageName = "\(imageID).png"
        
        //저장경로 -> picDownURL
        var folderPath = URL(fileURLWithPath: picDownURL.path)
        folderPath.appendPathComponent((imageName as NSString).lastPathComponent)
        
        if !fileManager.fileExists(atPath: folderPath.path) {
            fileManager.createFile(atPath: folderPath.path, contents: image.pngData(), attributes: nil)
        }
        return nil
    }
}
