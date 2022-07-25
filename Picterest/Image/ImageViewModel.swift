//
//  ImageViewModel.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import Foundation

class ImageViewModel {
    
    private let photoAPIService = PhotoAPIService()
    
    func getRandomPhoto(_ completion: @escaping (Result<PhotoData, APIError>) -> Void) {
        photoAPIService.getRandomPhoto(completion)
    }
}
