//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class PhotoListViewModel {
    let photoList: Observable<[Photo]> = Observable([])
    
    let starButtonTapped: Observable<(UIButton?, Photo?, UIImage?)> = Observable((nil, nil, nil))
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
        guard let folderURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("SavedPhotos") else { return }
        
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(
                    at: folderURL,
                    withIntermediateDirectories: true
                )
            } catch {
                return
            }
        }
        
        let writeURL = folderURL.appendingPathComponent(photoInfo.id + ".png")
        
        do {
            try image.pngData()?.write(to: writeURL)
        } catch {
            return
        }
        isSave.value = (sender, true)
    }
    
    func removePhoto(sender: UIButton, photoInfo: Photo) {
        guard let folderURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("SavedPhotos") else { return }
        
        let writedURL = folderURL.appendingPathComponent(photoInfo.id + ".png")
        do {
            try FileManager.default.removeItem(at: writedURL)
        } catch {
            return
        }
        isRemove.value = (sender, true)
    }
}
