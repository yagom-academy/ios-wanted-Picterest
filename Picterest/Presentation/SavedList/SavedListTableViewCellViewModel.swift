//
//  SavedListTableViewCellViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import UIKit

class SavedListTableViewCellViewModel {
    
    let image: Observable<UIImage?> = Observable(Icon.photo.image)
    
    init(savedPhoto: CoreSavedPhoto) {
        fetchPhoto(savedPhoto: savedPhoto)
    }
    
    func fetchPhoto(savedPhoto: CoreSavedPhoto) {
        guard let data = FileManager.fetch(fileName: savedPhoto.id) else { return }
        image.value = UIImage(data: data)
    }
}
