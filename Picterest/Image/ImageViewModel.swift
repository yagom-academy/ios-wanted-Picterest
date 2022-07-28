//
//  ImageViewModel.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

class ImageViewModel {
    
    private let photoAPIService = PhotoAPIService()
    
    func getRandomPhoto(_ page: Int, _ completion: @escaping (Result<[Photo], APIError>) -> Void) {
        photoAPIService.getRandomPhoto(page, completion)
    }
    
    func loadImage(_ url: String) -> UIImage {
        var img: UIImage?
        
        LoadImage().loadImage(url) { result in
            switch result {
            case .success(let image):
                img = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return img ?? UIImage()
    }
}
