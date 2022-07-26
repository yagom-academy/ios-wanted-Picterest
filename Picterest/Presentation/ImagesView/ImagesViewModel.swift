//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import UIKit

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
        let urlString = imageDatas[row].urls.regular
        
        return ImageData(imageURLString: urlString)
        
    }
    
    func imageSize(_ indexPath: IndexPath) -> CGSize {
        let row = indexPath.row
        let data = imageDatas[row]
        let height = data.height
        let width = data.width
        return CGSize(width: width, height: height)
    }
}
