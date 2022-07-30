//
//  SavedImageListViewModel.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation

class SavedImageListViewModel{
    private let coredataManager = CoredataManager.shared
    
    var imageList: [SavedImageViewModel] = [] {
        didSet {
            collectionViewUpdate()
        }
    }
    
    var collectionViewUpdate: () -> Void = {}
    
    func fetchSavedImageList() {
        coredataManager.loadCoredataImageInfo { decodingImageList in
            self.imageList = decodingImageList
        }
    }
    
    func imageViewModelAtIndexPath(index: Int) -> SavedImageViewModel {
        return imageList[index]
    }
    
    func getImageCount() -> Int {
        return imageList.count
    }
}
