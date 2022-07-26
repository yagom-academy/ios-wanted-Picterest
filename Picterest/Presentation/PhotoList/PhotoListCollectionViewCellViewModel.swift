//
//  PhotoListCollectionViewCellViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/26.
//

import UIKit

class PhotoListCollectionViewCellViewModel {
    
    let photo: Photo
    let image: Observable<UIImage> = Observable(UIImage())
    let starButtonTapped: Observable<Bool> = Observable(false)
    let imageTopViewModel = ImageTopViewModel()
    
    init(photo: Photo) {
        self.photo = photo
        downloadImage(urlString: photo.urls.regular)
        
        imageTopViewModel.starButtonTapped.bind {
            if $0 {
                self.starButtonTapped.value = $0
                self.imageTopViewModel.starButtonTapped.value = false
            }
        }
    }
    
    func downloadImage(urlString: String) {
        ImageLoader.shared.downloadImage(urlString: urlString) { result in
            switch result {
            case .success(let image):
                self.image.value = image
            case .failure(let error):
                print("ERROR \(error)👹")
            }
        }
    }
}
