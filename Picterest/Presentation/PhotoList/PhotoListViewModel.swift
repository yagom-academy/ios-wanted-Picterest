//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

final class PhotoListViewModel {
    let photoList: Observable<[Photo]> = Observable([])
    
    let starButtonTapped: Observable<(UIButton?, Photable?, UIImage?)> = Observable(
        (nil, nil, nil)
    )
    let isSave: Observable<(UIButton?, Bool)> = Observable((nil, false))
    let isRemove: Observable<(UIButton?, Bool)> = Observable((nil, false))
    let updateSavedList: Observable<Bool> = Observable(false)
    let updateStarButton: Observable<Bool> = Observable(false)
    
    var photoListCollectionViewCellViewModel: PhotoListCollectionViewCellViewModel? {
        willSet {
            newValue?.starButtonTapped.bind { [weak self] in
                self?.starButtonTapped.value = $0
            }
        }
    }
    
    var currentPage = 1
    
    func fetchPhotoList(page: Int) {
        Network(page: page).fetch { result in
            switch result {
            case .success(let photos):
                self.photoList.value.append(contentsOf: photos)
            case .failure(let error):
                debugPrint("ERROR \(error.description)😶‍🌫️")
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
        
        let newPhoto = CoreSavedPhoto(
            id: photoInfo.id,
            memo: memo,
            url: photoInfo.urls.raw,
            path: filePath ?? "",
            ratio: Double(photoInfo.height) / Double(photoInfo.width)
        )
        
        CoreDataManager.shared.save(newPhoto: newPhoto)
        
        isSave.value = (sender, true)
    }
    
    func removePhoto(sender: UIButton, photoInfo: Photo) {
        FileManager.remove(fileName: photoInfo.id)
        
        CoreDataManager.shared.remove(id: photoInfo.id)
        
        isRemove.value = (sender, true)
    }
}
