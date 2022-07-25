//
//  ImageListViewModel.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import Foundation

class ImageListViewModel {
    
    var repository = Repository()
    var imageList = [ImageData]()
    
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
    
    func list() {
        loading = true
        loadingStarted()
        repository.fetchImage { result in
            switch result {
            case .success(let imagelist):
                self.imageList = imagelist
                self.imageListUpdate()
                self.loadingEnded()
                self.loading = false
            case .failure(let error):
                print(error)
            }
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
    
}
