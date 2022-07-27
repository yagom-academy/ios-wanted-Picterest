//
//  ImageListViewModel.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

class ImageListViewModel {
    
    private var repository = Repository()
    private var imageList: [ImageData] = [ImageData]()
    private var imageSizeList = [CGFloat]()
    private var currentPage = 1
    
    private var loading = false
    
    var loadingStarted: () -> Void = { }
    var loadingEnded: () -> Void = { }
    var imageListUpdate: () -> Void = { }
    
    var imageCount: Int {
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
        resizingImage(page: currentPage) {
            self.imageListUpdate()
            self.loadingEnded()
            self.loading = false
        }
    }
    
    func next() {
        if loading { return }
        loading = true
        loadingStarted()
        currentPage+=1
        resizingImage(page: currentPage) {
            self.imageListUpdate()
            self.loadingEnded()
            self.loading = false
        }
    }
    
    func resizingImage(page: Int, completion: @escaping () -> Void) -> Void {
        repository.fetchNextImageData(page: page) { [self] result in
            switch result {
            case .success(let imageList):
                self.imageList += imageList
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
    
    private func getImageHeight(height: CGFloat, width: CGFloat) -> CGFloat {
        let scale = 150 / width
        return height * scale
    }
    
}
