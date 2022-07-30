//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

final class ImageCollectionViewModel {
    private var pageNumber = 1
    private var images: [Image] = [] {
        didSet {
            collectionViewUpdate()
        }
    }
    var collectionViewUpdate: () -> Void = {}
    var isFetching = false
    var imagesCount: Int {
        return images.count
    }
    
    func fetchImages(needToFetch: Bool = false) {
        if needToFetch { isFetching = true }
        NetworkManager.shared.fetchImageList(pageNumber: pageNumber) { [weak self] result in
            switch result {
            case .success(let images):
                if self?.pageNumber == 1 {
                    self?.images = images
                } else {
                    self?.images.append(contentsOf: images)
                }
                self?.pageNumber += 1
                self?.isFetching = false
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func image(at index: Int) -> ImageData {
        let targetData = images[index]
        let imageData = ImageData(image: targetData, memo: "", isSaved: checkFileExistInLocal(id: targetData.id))
        return imageData
    }

    func checkFileExistInLocal(id: String) -> Bool {
        let result = LocalFileManager.shared.checkFileExistInLocal(id: id)
        return result
    }
    
    func saveImage(_ data: Image, with memo: String) {
        DataManager.shared.save(data: data, with: memo, isSaved: true)
        collectionViewUpdate()
    }
    
    func deleteImage(_ data: Image) {
        DataManager.shared.delete(id: data.id)
        collectionViewUpdate()
    }
}
