//
//  SavedListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import UIKit

class SavedListViewModel {
    let starButtonTapped: Observable<(UIButton?, AAA?, UIImage?)> = Observable((nil, nil, nil))
    let isRemove: Observable<Bool> = Observable(false)
    var photoListCollectionViewCellViewModel: PhotoListCollectionViewCellViewModel? {
        willSet {
            newValue?.starButtonTapped.bind {
                self.starButtonTapped.value = $0
            }
        }
    }
    
    func makePhotoListCollectionViewCellViewModel(
        savedPhoto: CoreSavedPhoto
    ) -> PhotoListCollectionViewCellViewModel {
        let viewModel = PhotoListCollectionViewCellViewModel(photo: savedPhoto)
        photoListCollectionViewCellViewModel = viewModel
        return viewModel
    }
    
    func remove(savedPhoto: CoreSavedPhoto) {
        FileManager.remove(fileName: savedPhoto.id)
        CoreDataManager.shared.remove(id: savedPhoto.id)
        
        isRemove.value = true
    }
}
