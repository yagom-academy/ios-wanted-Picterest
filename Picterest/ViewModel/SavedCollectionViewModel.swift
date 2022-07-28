//
//  SavedCollectionViewModel.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import UIKit
import CloudKit

class SavedCollectionViewModel {
    private var savedImages: [SavedImageViewModel] = [] {
        didSet {
            scrollViewUpdate()
        }
    }
    
    var savedImagesCount: Int {
        return savedImages.count
    }
    
    var scrollViewUpdate: () -> Void = {}
    
    func fetchSavedData() {
        let imageInfoData = CoreDataManager.shared.loadData()
        imageInfoData.forEach {
            guard let id = $0.id,
                  let memo = $0.memo,
                  let url = $0.url else { return }
            let width = Int($0.width)
            let height = Int($0.height)
            let savedData = SavedImageViewModel(image: Image(id: id, width: width, height: height, urls: URLs(thumb: url)),
                                                memo: memo)
            savedImages.append(savedData)
        }
    }
    
    func imageAtIndex(_ index: Int) -> SavedImageViewModel {
        return savedImages[index]
    }
}

class SavedImageViewModel {
    
    var image: Image
    var memo: String

    init(image: Image, memo: String) {
        self.image = image
        self.memo = memo
    }
    
    var id: String {
        return image.id
    }
    
    var width: Int {
        return image.width
    }
    
    var height: Int {
        return image.height
    }
}

