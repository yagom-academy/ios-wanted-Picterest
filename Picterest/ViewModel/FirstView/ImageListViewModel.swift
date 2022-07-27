//
//  ImageListViewModel.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation

class ImageListViewModel {
    private let networkManager = NetworkManager()
    var isPaginating = false
    var imageList: [ImageModel] = [] {
        didSet {
            collectionViewUpdate()
        }
    }
    
    var collectionViewUpdate: () -> Void = {}
    
    func fetchImages(pagination: Bool = false) {
        if pagination {
            isPaginating = true
        }
        self.networkManager.fetchImageList() { [weak self] result in
            switch result {
            case .success(let reviews):
                self?.imageList.append(contentsOf: reviews)
            case .failure(let error):
                print(error.localizedDescription)
            }
            if pagination {
                self?.isPaginating = false
            }
        }
    }
    
    func imageViewModelAtIndexPath(index: Int) -> ImageViewModel {
        var imageViewModel = ImageViewModel(image: imageList[index])
        imageViewModel.isSaved = LocalImageFileManager.shared.checkImageInLocal(id: imageViewModel.id)
        return imageViewModel
    }
    
    func getImageCount() -> Int {
        return imageList.count
    }
}
