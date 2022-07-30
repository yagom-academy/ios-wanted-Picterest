//
//  SavedCollectionViewModel.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import UIKit

final class SavedCollectionViewModel {
    private var savedImages: [ImageData] = []
    
    var savedImagesCount: Int {
        return savedImages.count
    }
    
    var savedImagesUpdated: () -> Void = {}
    
    func fetchSavedData() {
        let imageInfoData = CoreDataManager.shared.loadData()
        imageInfoData.forEach {
            guard let id = $0.id,
                  let memo = $0.memo,
                  let url = $0.url else { return }
            let width = Int($0.width)
            let height = Int($0.height)
            let savedData = ImageData(
                image: Image(
                    id: id,
                    width: width,
                    height: height,
                    urls: URLs(small: url)
                ),
                memo: memo,
                isSaved: true
            )
            savedImages.append(savedData)
        }
        DispatchQueue.main.async {
            self.savedImagesUpdated()
        }
    }
    
    func deleteData(at index: Int) {
        DataManager.shared.delete(id: savedImages[index].image.id)
        savedImages.remove(at: index)
        self.savedImagesUpdated()
    }
    
    func refreshData() {
        savedImages.removeAll()
        fetchSavedData()
        self.savedImagesUpdated()
    }
    
    func image(at index: Int) -> ImageData {
        return savedImages[index]
    }
}
