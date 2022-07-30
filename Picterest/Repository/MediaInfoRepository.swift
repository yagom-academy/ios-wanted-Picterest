//
//  PhotoInfoRepository.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import Foundation
import UIKit
import CoreData

class MediaInfoRepository {
    private let provider: Provider
    private let fileManger: FileManged
    private let coreDataStarge: CoreDataStorage
    private var currentPage: Int = 1
    private var imageCache = NSCache<NSURL,NSData>()
    
    
    init(provider: Provider = ProviderImpl(),
         filemanger: FileManged = ImageFileManger(),
         coreDataStarge: CoreDataStorage = ImageDataCoreDataStorage()) {
        self.provider = provider
        self.fileManger = filemanger
        self.coreDataStarge = coreDataStarge
    }
    
    func getPhotoList(completion: @escaping (Result<[PhotoInfo],Error>) -> Void) {
        let photoListRequestDTO = PhotoInfoRequestDTO(page: currentPage)
        let endpoint = APIEndpoints.getPhotosInfo(with: photoListRequestDTO)
        currentPage += 1
        provider.request(with: endpoint) { result in
            switch result {
            case .success(let responesDTO):
                var photoInfoList = [PhotoInfo]()
                responesDTO.forEach { info in
                    var model = info.toDomain()
                    let request: NSFetchRequest<ImageData> = ImageData.fetchRequest()
                    self.coreDataStarge.fetch(request: request) { result in
                        switch result {
                        case .success(let imageDatas):
                            imageDatas.forEach { imageData in
                                if imageData.id == model.id {
                                    model.isSaved = true
                                }
                            }
                            photoInfoList.append(model)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
                completion(.success(photoInfoList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getImageList(completion: @escaping (Result<[ImageInfo],Error>) -> Void) {
        let request: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        coreDataStarge.fetch(request: request) { result in
            switch result {
            case .success(let imageDatas) :
                var ImageInfoList = [ImageInfo]()
                imageDatas.forEach { imagedata in
                    guard let id = imagedata.id,
                          let memo = imagedata.memo,
                          let orginUrl = imagedata.orginUrl,
                          let locationUrl = imagedata.locationUrl else {
                        completion(.failure(NetworkError.parsingError))
                        return }
                    let imageInfo = ImageInfo(id: id, memo: memo, orginUrl: orginUrl, locationUrl: locationUrl, ratio:imagedata.ratio)
                    ImageInfoList.append(imageInfo)
                }
                completion(.success(ImageInfoList))
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
    
    func loadImage(url: String, completion: @escaping (Result<Data,Error>) -> Void) {
        if let url = NSURL(string: url), let data = imageCache.object(forKey: url) {
            completion(.success(data as Data))
        } else {
            if let url = URL(string: url) {
                provider.request(url) { result in
                    switch result {
                    case .success(let data):
                        self.imageCache.setObject(data as NSData, forKey: url as NSURL)
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func loadLocalImage(imageInfo: ImageInfo, completion: @escaping ((Result<UIImage,Error>) -> Void)){
        if let image = fileManger.getSavedImage(named: imageInfo.id) {
            completion(.success(image))
        } else {
            loadImage(url: imageInfo.orginUrl) { result in
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
    }
    
    func savedImage(image: UIImage, memo: String, photoInfo: PhotoInfo, completion: @escaping (Result<Bool,Error>) -> Void) {
        fileManger.saveImage(image: image, name: photoInfo.id) { result in
            switch result {
            case .success(let fileName) :
                let ratio = Float(photoInfo.height) / Float(photoInfo.width)
                let imageInfo = ImageInfo(id: photoInfo.id, memo: memo, orginUrl: photoInfo.urls.small, locationUrl: fileName,ratio: ratio)
                self.coreDataStarge.insertImageinfo(imageInfo: imageInfo) { result in
                    switch result {
                    case .success(let isSaved) :
                        completion(.success(isSaved))
                    case .failure(let error) :
                        completion(.failure(error))
                    }
                }
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
    
    func deleteImage(id: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        fileManger.deleteImage(named: id) { result in
            print(result)
        }
        let request: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        coreDataStarge.fetch(request: request) { result in
            switch result {
            case .success(let imageDatas) :
                let index = imageDatas.firstIndex { $0.id == id}
                if let index = index {
                    self.coreDataStarge.delete(object: imageDatas[index]) { result in
                        switch result {
                        case .success(let isDelete) :
                            completion(.success(isDelete))
                        case .failure(let error) :
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
}
