//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import Foundation

class PhotoListViewModel {
    let photoList: Observable<[Photo]> = Observable([])
    
    func fetchPhotoList() {
        Network.shard.get { result in
            switch result {
            case .success(let photos):
                self.photoList.value = photos
            case .failure(let error):
                print("ERROR \(error)😶‍🌫️")
            }
        }
    }
}
