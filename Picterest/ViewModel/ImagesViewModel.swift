//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation
import Combine

final class ImagesViewModel {
    
    @Published var images = [PhotoModel]()
    private let networkManager = NetworkManager()
    
    func getImagesCount() -> Int {
        images.count
    }
    
    func getImage(of index: Int) -> PhotoModel {
        return images[index]
    }
    
    func fetch() {
        networkManager.fetchData { images in
            self.images = images
        }
    }
}

