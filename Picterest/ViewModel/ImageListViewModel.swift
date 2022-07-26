//
//  ImageListViewModel.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import Foundation

class ImageListViewModel {
    private let networkManager = NetworkManager()
    var imageList: [Image] = [] {
        didSet {
            collectionViewUpdate()
        }
    }
    
    var collectionViewUpdate: () -> Void = {}
    
    func fetchRandomImages() {
        self.networkManager.fetchImageList { [weak self] result in
            switch result {
            case .success(let reviews):
                self?.imageList.append(contentsOf: reviews)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imageViewModelAtIndexPath(index: Int) -> ImageViewModel {
        return ImageViewModel(image: imageList[index])
    }
    
    func getImageCount() -> Int {
        return imageList.count
    }
}
