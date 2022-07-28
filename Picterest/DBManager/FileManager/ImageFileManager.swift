//
//  ImageFileManager.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/28.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() { }
    
    private let fileManager = FileManager.default
    private let documentPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveImageByURL(imageURL: String?, id: UUID, completion: @escaping (Result<Void,DBManagerError>) -> ()) {
        guard let urlString = imageURL else {
            completion(.failure(.badURL))
            return
        }
        let filename = id.uuidString
        let cachedImage = ImageCacheManager.shared.cachedImage(urlString: urlString)
        if cachedImage != nil {
            let result = saveImage(filename: filename, image: cachedImage)
            completion(result ? .success(Void()) : .failure(.failToSaveImageFile))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                    let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                completion(.failure(.failParsingToImage))
                return
            }
            ImageCacheManager.shared.setObject(image: image, urlString: urlString)
            guard let result = self?.saveImage(filename: filename, image: image) else {
                completion(.failure(.failToSaveImageFile))
                return }
            completion(result ? .success(Void()) : .failure(.failToSaveImageFile))
        }.resume()
    }
    
    func saveImage(filename: String, image: UIImage?) -> Bool {
        guard let image = image else {
            return false
        }
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return false }
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
//            let filename = formatter.string(from: Date.now)
            print(documentPath)
            try imageData.write(to: documentPath.appendingPathComponent(filename + ".png"))
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        let result = UIImage(contentsOfFile: URL(fileURLWithPath: documentPath.absoluteString).appendingPathComponent(named).path)
        return result
    }
}
