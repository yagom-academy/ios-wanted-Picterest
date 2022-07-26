//
//  SavedImageListViewModel.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation

class SavedImageListViewModel{
    private let coredataManager = CoredataManager()
    
    var imageList: [SavedImageViewModel] = [] {
        didSet {
            collectionViewUpdate()
        }
    }
    
    var collectionViewUpdate: () -> Void = {}
    
    func fetchSavedImageList() {
        print("fetch")
        coredataManager.loadCoredataImageInfo { decodingImageList in
            self.imageList = decodingImageList
            print(self.imageList)
        }
    }
    
    func imageViewModelAtIndexPath(index: Int) -> SavedImageViewModel {
        return imageList[index]
    }
    
    func getImageCount() -> Int {
        return imageList.count
    }
}
