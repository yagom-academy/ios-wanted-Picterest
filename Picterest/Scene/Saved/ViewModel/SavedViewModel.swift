//
//  SavedViewModel.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation
import UIKit
import CoreData

class SavedViewModel {
    private let repository = MediaInfoRepository()
    var imageInfoList = Observable<[ImageInfo]>([])
    
    subscript(indexPath: IndexPath) -> ImageInfo {
        return imageInfoList.value[indexPath.row]
    }
    
    func deleteImage(id: String) {
        repository.deleteImage(id: id) { [weak self] result in
            switch result {
            case .success(let isDeleted) :
                if isDeleted {
                    if let index = self?.imageInfoList.value.firstIndex(where: {$0.id == id}){
                        self?.imageInfoList.value.remove(at: index)
                    }
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func viewImageList() {
        repository.getImageList { [weak self] result in
            switch result {
            case .success(let imageList):
                self?.imageInfoList.value = imageList
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadLocalImage(imageInfo: ImageInfo, completion: @escaping ((Result<UIImage,Error>) -> Void)){
        repository.loadLocalImage(imageInfo: imageInfo) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
