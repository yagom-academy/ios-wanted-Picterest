//
//  ImageManager.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import Foundation


final class ImageManager {
  
  static let shared = ImageManager()
  private let fileManager =  FileManager()
  private var imageCache = NSCache<NSString,NSData>()
  
  private init(){}
  
  func loadImage(url:URL, completion: @escaping (Data?) -> Void) {
    if let data = imageCache.object(forKey: url.lastPathComponent as NSString) {
      completion(data as Data)
      return
    }
    
    let URLRequest = URLRequest(url: url)
    NetworkService.request(on: URLRequest) {[weak self] result in
      switch result{
      case .success(let data):
        completion(data)
        self?.imageCache.setObject(data as NSData, forKey: url.lastPathComponent as NSString)
      case .failure(_):
        completion(nil)
      }
    }
  }
  
  func saveImage(_ imageEntity: ImageEntity) {
    guard let filePath = makePath(with: imageEntity.imageURL),
            let image = imageEntity.image else {return}
    if !fileManager.fileExists(atPath: filePath.path) {
      fileManager.createFile(atPath: filePath.path, contents: image.jpegData(compressionQuality: 0.4),attributes: nil)
    }
    //TODO: CoreDataManager 를 이용해서 CoreDB 에 저장
  }
  
}

private extension ImageManager {
  
  func makePath(with url: URL) -> URL? {
    guard let path = NSSearchPathForDirectoriesInDomains(.downloadsDirectory,
                                                         .userDomainMask, true).first
    else {
      return nil
    }
    
    var filePath = URL(fileURLWithPath: path)
    filePath.appendPathComponent(url.lastPathComponent)
    return filePath
  }

}
