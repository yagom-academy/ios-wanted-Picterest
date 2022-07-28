//
//  SavedViewModel.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import Foundation
import Combine

final class SavedViewModel {
    
    @Published var images = [ImageCoreDataModel]()
    private let coreDataManager = CoreDataManager.shared
    
    
    func getImagesCount() -> Int {
        return images.count
    }
    
    func getImage(at index: Int) -> ImageCoreDataModel? {
        if index < 0 || index >= images.count {
            return nil
        }
        return images[index]
    }
    
    func fetch() {
        guard let images = self.coreDataManager.load() else {
            print("coreDataManager.load error")
            return
        }
        self.images = images
    }
}
