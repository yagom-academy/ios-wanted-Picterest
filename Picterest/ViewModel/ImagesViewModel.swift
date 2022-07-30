//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation

final class ImagesViewModel {
    
    private let networkManager = NetworkManager()
    private var images = [ImageInformation]()
    
    private var pageIndex = 1
    private let numberOfImagesPerPage = 15
    private let downloadURL = "https://api.unsplash.com/photos"
    private let clientKey = "7ALCpoVug3GfgRPsqELTFsDKYeG_wDhaXCNhabb9j1Q"
}

// MARK: - Public

extension ImagesViewModel {
    func getNumberOfImages() -> Int {
        return images.count
    }
    
    func getImage(at index: Int) -> ImageInformation? {
        if index < 0 || index >= images.count {
            return nil
        }
        return images[index]
    }
    
    func fetch(completion: @escaping () -> Void) {
        guard let url = URL(string: downloadURL + "?" + "client_id=\(clientKey)" + "&per_page=\(numberOfImagesPerPage)" + "&page=\(pageIndex)") else {
            return
        }
        
        networkManager.fetchData(url: url) { images in
            for photo in images {
                self.images.append(photo)
            }
            completion()
        
        }
        
        increasePageIndex()
    }
}

// MARK: - Private

extension ImagesViewModel {
    private func increasePageIndex() {
        pageIndex += 1
    }
}

