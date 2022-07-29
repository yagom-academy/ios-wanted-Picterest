//
//  ImageManager.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

final class ImageManager {
  
  static let shared = ImageManager()
  private let fileManager =  FileManager.default
  private let coreDataManager = CoreDataManager.shared
  private var imageCache = NSCache<NSString,NSData>()
  
  private init(){}
  
  func loadImage(urlSource: ImageEntity, completion: @escaping (Data?) -> Void) {
    //Search Data in Memory

    if let data = imageCache.object(forKey: urlSource.imageURL.lastPathComponent as NSString) {
      completion(data as Data)
      return
    }
    
    //TODO: Search Image data in Disk
    if let image = getSavedImage(named: urlSource.imageURL.lastPathComponent) {
      completion(makeImageData(image: image))
    }
    
    let URLRequest = URLRequest(url: urlSource.imageURL)
    NetworkService.request(on: URLRequest) {[weak self] result in
      switch result{
      case .success(let data):
        completion(data)
        self?.imageCache.setObject(data as NSData, forKey: urlSource.imageURL.lastPathComponent as NSString)
      case .failure(_):
        completion(nil)
      }
    }
  }
  

  func saveImage(_ imageEntity: ImageEntity, completion: @escaping ((Error?) -> Void)) {
    guard let directory = makePath(with: imageEntity.imageURL),
          let imageData = makeImageData(image: imageEntity.image) else {return}
    imageEntity.saveStoredDirectory(url: directory.appendingPathComponent(imageEntity.imageURL.lastPathComponent))
    do {
      try imageData.write(to: directory.appendingPathComponent(imageEntity.imageURL.lastPathComponent))
      print("\(imageEntity.storedDirectory) 에 저장됨")
      coreDataManager.insert(imageEntity)
      completion(nil)
    } catch {
      completion(error)
    }
  }
  
  func loadSavedImage() -> [ImageData] {
    guard let data = coreDataManager.fetchImages() else {return []}
    return data
  }
  
  func deleteSavedImage(imageEntity: ImageEntity, completion: @escaping ((Error?) -> Void)) {
    guard let storedDirectory = imageEntity.storedDirectory else {return}
    do {
      try fileManager.removeItem(at: storedDirectory)
      coreDataManager.delete(imageEntity)
      completion(nil)
    }catch{
      completion(error)
    }
  }
  

  func getSavedImage(named: String) -> UIImage? {
    if let dir: URL
        = try? FileManager.default.url(for: .downloadsDirectory,
                                     in: .userDomainMask,
                                     appropriateFor: nil,
                                     create: false) {
      let path: String
        = URL(fileURLWithPath: dir.absoluteString)
            .appendingPathComponent(named).path
      let image: UIImage? = UIImage(contentsOfFile: path)
      return image
    }
    return nil
  }
}

private extension ImageManager {
  
  func makePath(with url: URL) -> URL? {
    guard let directory = try? FileManager.default.url(for: .downloadsDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) as URL
    else {
      return nil
    }
    return directory
  }
  
  func makeImageData(image: UIImage?) -> Data? {
    guard let image = image,
          let data = image.jpegData(compressionQuality: 1) ?? image.pngData()
    else {
      return nil
    }
    return data
  }
}
