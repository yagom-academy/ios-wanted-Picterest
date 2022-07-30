//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/27.
//

import UIKit

final class ImageCollectionViewModel {
    private var pageNumber = 1
    private var images: [ImageData] = [] {
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
                let imageData = images.map { ImageData(image: $0, memo: "", isSaved: false)}
                if self?.pageNumber == 1 {
                    self?.images = imageData
                } else {
                    self?.images.append(contentsOf: imageData)
                }
                self?.pageNumber += 1
                self?.isFetching = false
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func image(at index: Int) -> ImageData {
        let id = images[index].image.id
        let width = images[index].image.width
        let height = images[index].image.height
        let urls = images[index].image.urls
        return ImageData(image: Image(id: id, width: width, height: height, urls: urls), memo: "", isSaved: false)
    }
    
    func checkFileExistInLocal(data: Image) -> Bool {
        let result = LocalFileManager.shared.checkFileExistInLocal(id: data.id)
        return result
    }
    
    func save(data: Image, with memo: String) {
        DataManager.shared.save(data: data, memo: memo)
    }
    
    func deleteImage(id: String) {
        DataManager.shared.delete(id: id)
    }
}
