//
//  ImageViewModel.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

class ImageViewModel {
    
    private let photoAPIService = PhotoAPIService()
    
    func getPhoto(_ page: Int, _ completion: @escaping (Result<[Photo], APIError>) -> Void) {
        photoAPIService.getPhoto(page, completion)
    }
    
    func loadImage(_ url: String) -> UIImage {
        var img: UIImage?
        
        LoadImage().loadImage(url) { result in
            switch result {
            case .success(let image):
                img = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return img ?? UIImage()
    }
    
    func savePhoto(_ photoData: Photo, _ memo: String) {
        let id = photoData.id
        let originUrl = photoData.urls.small
        let location = PhotoFileManager.shared.createPhotoFile(loadImage(originUrl), id).absoluteString
        let ratio = photoData.height / photoData.width
        
        CoreDataManager.shared.createSavePhoto(id, memo, originUrl, location, ratio)
    }
    
    func deletePhoto(_ photoData: Photo) {
        PhotoFileManager.shared.deletePhotoFile(photoData.urls.small)
        guard let entity = CoreDataManager.shared.searchSavePhoto(photoData.id) else { return }
        CoreDataManager.shared.deleteSavePhoto(entity)
    }
}
