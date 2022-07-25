//
//  ImageListViewModel.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import Foundation
import UIKit
class ImageListViewModel {
    
    var repository = Repository()
    var imageList = [ImageData]()
    var imageSizeList = [CGFloat]()
    
    private var loading = false
    
    var loadingStarted: () -> Void = { }
    var loadingEnded: () -> Void = { }
    var imageListUpdate: () -> Void = { }
    
    
    func imageCount() -> Int {
        return imageList.count
    }
    
    func image(at index: Int) -> ImageData {
        return imageList[index]
    }
    
    func imageSize(at index: Int) -> CGFloat {
        return imageSizeList[index]
    }
    
    func list() {
        loading = true
        loadingStarted()
        resizingImage {
            self.imageListUpdate()
            self.loadingEnded()
            self.loading = false
        }
    }
    
    func next() {
        if loading { return }
        loading = true
        loadingStarted()
//        repository.next(currentPage: lectureList) {
//            var lectureList = $0
//            lectureList.lectures.insert(contentsOf: self.lectureList.lectures, at: 0)
//            self.lectureList = lectureList
//            self.lectureListUpdated()
//            self.loadingEnded()
//            self.loading = false
//        }
    }
    
    func resizingImage(completion: @escaping () -> Void) -> Void {
        repository.fetchImage { [self] result in
            switch result {
            case .success(let imagelist):
                self.imageList = imagelist
                imageList.forEach {
                    let height = getImageHeight(height: CGFloat($0.height), width: CGFloat($0.width))
                    imageSizeList.append(height)
                }
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImageHeight(height: CGFloat, width: CGFloat) -> CGFloat {
        let scale = 150 / width
        return height * scale
    }
    
}
