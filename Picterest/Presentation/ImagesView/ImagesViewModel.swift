//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import UIKit

final class ImagesViewModel {
    
    // MARK: - Properties
    struct SaveData {
        var imageURLString: String
        var imageID: String
    }
    
    private var imageDatas: [ImageInfo] = []
    private var saveDatas: [SaveData] = []
    var imagedDataCount:Int {
        return saveDatas.count
    }
    
    func fetchData(completion: @escaping () -> ()) {
        
        NetworkManager.shared.fetchImages { result in
            switch result {
            case .success(let result):
                self.imageDatas = result
                self.saveDatas = result.map({ imageInfo in
                    SaveData(imageURLString: imageInfo.urls.regular, imageID: imageInfo.id)
                })
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImage(index: IndexPath, completion: @escaping (Result<Void, Error>) -> ()) {
        let imageURL = saveDatas[index.row].imageURLString
        let imageId = saveDatas[index.row].imageID
        ImageFileManager.shared.saveImageUrl(imageUrl: imageURL, imageID: imageId) {  result in
            switch result {
            case.success(let path):
                print(path)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imageData(indexPath: IndexPath) -> SaveData? {
        
        let row = indexPath.row
        guard row < imagedDataCount else { return nil }
        let urlString = imageDatas[row].urls.regular
        let id = imageDatas[row].id
        return SaveData(imageURLString: urlString, imageID: id)
        
    }
    
    func imageSize(_ indexPath: IndexPath) -> CGSize {
        let row = indexPath.row
        let data = imageDatas[row]
        let height = data.height
        let width = data.width
        return CGSize(width: width, height: height)
    }
}
