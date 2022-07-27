//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class PhotoListViewModel {
    let photoList: Observable<[Photo]> = Observable([])
    
    let starButtonTapped: Observable<(UIButton?, AAA?, UIImage?)> = Observable((nil, nil, nil))
    let isSave: Observable<(UIButton?, Bool)> = Observable((nil, false))
    let isRemove: Observable<(UIButton?, Bool)> = Observable((nil, false))
    
    var photoListCollectionViewCellViewModel: PhotoListCollectionViewCellViewModel? {
        willSet {
            newValue?.starButtonTapped.bind {
                self.starButtonTapped.value = $0
            }
        }
    }
    
    func fetchPhotoList() {
        Network.shard.get { result in
            switch result {
            case .success(let photos):
                self.photoList.value = photos
            case .failure(let error):
                print("ERROR \(error)😶‍🌫️")
            }
        }
    }
    
    func makePhotoListCollectionViewCellViewModel(
        photo: Photo
    ) -> PhotoListCollectionViewCellViewModel {
        let viewModel = PhotoListCollectionViewCellViewModel(photo: photo)
        photoListCollectionViewCellViewModel = viewModel
        return viewModel
    }
    
    func savePhoto(sender: UIButton, photoInfo: Photo, memo: String, image: UIImage) {
        let filePath = FileManager.save(
            data: image.pngData(),
            fileName: photoInfo.id
        )
        
        isSave.value = (sender, true)
        
        let newPhoto = CoreSavedPhoto(
            id: photoInfo.id,
            memo: memo,
            url: photoInfo.urls.raw,
            path: filePath ?? "",
            ratio: Double(photoInfo.height) / Double(photoInfo.width)
        )
        
        CoreDataManager.shared.save(newPhoto: newPhoto)
    }
    
    func removePhoto(sender: UIButton, photoInfo: Photo) {
        FileManager.remove(fileName: photoInfo.id)
        isRemove.value = (sender, true)
        
        CoreDataManager.shared.remove(id: photoInfo.id)
    }
}
