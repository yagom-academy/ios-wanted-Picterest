//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

class PhotoListViewModel {
    let photoList: Observable<[Photo]> = Observable([])
    
    let starButtonTapped: Observable<Bool> = Observable(false)
    
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
    
    func makePhotoListCollectionViewCellViewModel(photo: Photo) -> PhotoListCollectionViewCellViewModel {
        let viewModel = PhotoListCollectionViewCellViewModel(photo: photo)
        photoListCollectionViewCellViewModel = viewModel
        return viewModel
    }
    
    func savePhoto(memo: String?) {
        print(memo)
    }
}
