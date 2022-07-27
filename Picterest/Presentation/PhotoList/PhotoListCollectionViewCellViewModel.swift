//
//  PhotoListCollectionViewCellViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/26.
//

import UIKit

class PhotoListCollectionViewCellViewModel {
    
    let photo: AAA
    let image: Observable<UIImage> = Observable(UIImage())
    let starButtonTapped: Observable<(UIButton?, Photo?, UIImage?)> = Observable((nil, nil, nil))
    let imageTopViewModel = ImageTopViewModel()
    
    init(photo: AAA) {
        self.photo = photo
        if let photo = photo as? Photo {
            downloadImage(urlString: photo.urls.regular)
            
            imageTopViewModel.starButtonTapped.bind {
                if $0 != nil {
                    self.starButtonTapped.value = ($0, photo, self.image.value)
                    self.imageTopViewModel.starButtonTapped.value = nil
                }
            }
        } else if let savedPhoto = photo as? CoreSavedPhoto {
            if let data = FileManager.fetch(fileName: savedPhoto.id),
               let savedImage = UIImage(data: data) {
                image.value = savedImage
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

