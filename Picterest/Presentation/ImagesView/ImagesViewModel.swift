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
        var isSaved: Bool
        var width: CGFloat
        var height: CGFloat
        mutating func toggleSavedState() {
            self.isSaved = !self.isSaved
        }
    }
    
    private var saveDatas: [SaveData] = []
    var imagedDataCount:Int {
        return saveDatas.count
    }
    
    func fetchData(completion: @escaping () -> ()) {
        
        NetworkManager.shared.fetchImages { result in
            switch result {
            case .success(let result):
                self.saveDatas = result.map({ imageInfo in
                    let isSaved: Bool = CoreDataManager.shared.isSavedImage(originUrl:imageInfo.urls.regular)
                    let width = CGFloat(imageInfo.width)
                    let height = CGFloat(imageInfo.height)
                    return  SaveData(imageURLString: imageInfo.urls.regular, imageID: imageInfo.id, isSaved: isSaved, width: width, height: height)
                })
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImageInfos(index: IndexPath, memo: String, completion: @escaping (Result<Void, Error>) -> ()) {
        
        let saveData = saveDatas[index.row]
        //코어데이터 저장 목록 2.사진 원본 url(웹API)
        let imageURL = saveData.imageURLString
        
        //코어데이터 저장 목록 3.사진ID
        let imageId = saveData.imageID
        
        
        //파일매니저에는 이미지 파일만 저장
        ImageFileManager.shared.saveImageUrl(imageUrl: imageURL, imageID: imageId) {  result in
            switch result {
            case.success(let path):
                let width = saveData.width
                let height = saveData.height
                CoreDataManager.shared.createImageInfo(id: imageId, memo: memo, originUrl: imageURL, savePath: path, width: width, height: height)
                
                self.saveDatas[index.row].toggleSavedState()
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imageData(indexPath: IndexPath) -> SaveData? {
        return saveDatas[safe: indexPath.row]
    }
    
    func imageSize(_ indexPath: IndexPath) -> CGSize {
        let row = indexPath.row
        let data = saveDatas[row]
        let height = data.height
        let width = data.width
        return CGSize(width: width, height: height)
    }
    
    func updateSavedDatasSate() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            for i in 0..<self.saveDatas.count {
                guard let cell = self.saveDatas[safe: i] else { return }
                self.saveDatas[i].isSaved = CoreDataManager.shared.isSavedImage(originUrl: cell.imageURLString)
            }
        }
    }
}
