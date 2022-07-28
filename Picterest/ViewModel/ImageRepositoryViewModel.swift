//
//  ImageRepositoryViewModel.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/27.
//

import UIKit

class ImageRepositoryViewModel {
    
    private var imageList: [Picture] = [Picture]()
    
    var imageListUpdate: () -> Void = { }
    var imageListUpdateAfterDelete: () -> Void = { }
    
    var imageCount: Int {
        return imageList.count
    }
    
    func image(at index: Int) -> Picture {
        return imageList[index]
    }
    
    func imageSize(at index: Int) -> CGFloat {
        return CGFloat(Int(imageList[index].imageSize!) ?? 0)
    }
    
    func deleteImage(at indexPath: IndexPath) {
        let item = imageList[indexPath.item]
        CoreDataManager.shared.delete(entity: item)
        PicterestFileManager.shared.deletePicture(fileName: item.id!)
        imageList.remove(at: indexPath.row)
        self.imageListUpdateAfterDelete()
    }
    
    func list() {
        imageList.removeAll()
        imageList = CoreDataManager.shared.fetchPicture()
        self.imageListUpdate()
    }
}
