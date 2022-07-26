//
//  PhotoListViewModel.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import Foundation
import Combine

class PhotoListViewModel : ObservableObject {
    
    @Published var photoList : [Photo]?
    var pageNumber = 1
    var perPage = 15
    let photoManager = PhotoManager()

    func getDataFromServer() {
        photoManager.getData(perPage, pageNumber) { [weak self] photoList in
            if self?.photoList == nil {
                self?.photoList = photoList
            } else {
                self?.photoList?.append(contentsOf: photoList)
            }
        }
        pageNumber += 1
    }
}
