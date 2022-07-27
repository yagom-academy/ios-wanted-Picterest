//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation
import Combine

final class ImagesViewModel {
    
    @Published var images = [ImageData]()
    
    private var pageIndex = 1
    private let numberOfImages = 15
    private let downloadURL = "https://api.unsplash.com/photos"
    private let clientKey = "7ALCpoVug3GfgRPsqELTFsDKYeG_wDhaXCNhabb9j1Q"
    private let networkManager = NetworkManager()
    
    func getImagesCount() -> Int {
        return images.count
    }
    
    func getImage(at index: Int) -> ImageData {
        return images[index]
    }
    
    func getID(at index: Int) -> String {
        return images[index].id
    }
    
    func fetch() {
        guard let url = URL(string: downloadURL + "?" + "client_id=\(clientKey)" + "&per_page=\(numberOfImages)" + "&page=\(pageIndex)") else {
            print("Uncorrect url")
            return
        }
        
        networkManager.fetchData(url: url) { images in
            for photo in images {
                self.images.append(photo)
            }
        }
    }
    
    func increasePageIndex() {
        pageIndex += 1
    }
}

