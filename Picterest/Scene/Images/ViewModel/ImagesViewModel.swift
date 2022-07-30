//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation
import UIKit

class ImagesViewModel {
    private let repository = MediaInfoRepository()
    var photoList = Observable<[PhotoInfo]>([])
    
    subscript(indexPath: IndexPath) -> PhotoInfo {
        return photoList.value[indexPath.row]
    }
    
    func viewPhotoList() {
        repository.getPhotoList { [weak self] result in
            switch result {
            case .success(let photoInfos):
                self?.photoList.value.append(contentsOf: photoInfos)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadImage(url: String, completion:@escaping (Result<UIImage,Error>) -> Void){
        repository.loadImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.parsingError))
                    return
                }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func savedImage(image: UIImage, memo: String, photoInfo: PhotoInfo) {
        repository.savedImage(image: image, memo: memo, photoInfo: photoInfo) { result in
            switch result {
            case .success(let isSaved) :
                if isSaved {
                    NotificationCenter.default.post(name: .imageDataStatusChange, object: nil)
                }
            case .failure(let error) :
                print(error)
            }
            
        }
    }
    
    func deleteImage(id: String) {
        repository.deleteImage(id: id,completion: { result in
            switch result {
            case .success(let isDeleted) :
                if isDeleted {
                    NotificationCenter.default.post(name: .imageDataStatusChange, object: nil)
                }
            case .failure(let error) :
                print(error)
            }
        })
        
    }
    
}
