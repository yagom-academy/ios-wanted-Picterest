//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import Foundation

final class ImagesViewModel {
    
    // MARK: - Properties
    struct ImageData {
        var imageURLString: String
    }
    
    private var imageDatas: [ImageInfo] = []
    var imagedDataCount:Int {
        return imageDatas.count
    }
    
    func fetchData(completion: @escaping () -> ()) {
        
        NetworkManager.shard.fetchImages { result in
            switch result {
            case .success(let result):
                self.imageDatas = result
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imageData(indexPath: IndexPath) -> ImageData? {
        
        let row = indexPath.row
        guard row < imagedDataCount else { return nil }
        let urlString = self.imageDatas[row].urls.regular
        
        return ImageData(imageURLString: urlString)
        
    }
}
