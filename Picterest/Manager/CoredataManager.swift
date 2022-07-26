//
//  CoredataManager.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/26.
//

import Foundation
import UIKit
import CoreData

class CoredataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func setImageInfo(_ imageViewModel: ImageViewModel, memo: String, saveLocation: String) {
        let newImageInfo = ImageInfo(context: context)
        newImageInfo.id = imageViewModel.id
        newImageInfo.memo = memo
        newImageInfo.originURL = URL(string: imageViewModel.url) 
        newImageInfo.saveLocation = saveLocation
        newImageInfo.height = imageViewModel.height
        newImageInfo.width = imageViewModel.width
        saveImageInfo()
    }
    
    func loadCoredataImageInfo(completion: @escaping ([SavedImageViewModel]) -> Void ) {
        let request: NSFetchRequest<ImageInfo> = ImageInfo.fetchRequest()
        do {
            var fetchDecodingCoredataArray : [SavedImageViewModel] = []
            let coredataItemList = try context.fetch(request)
            for data in coredataItemList {
                guard let id = data.value(forKey: "id") as? String else { return }
                guard let url = data.value(forKey: "originURL") as? URL else { return }
                let urlString = "\(url)"
                guard let width = data.value(forKey: "width") as? Double else { return }
                guard let height = data.value(forKey: "height") as? Double else { return }
                guard let memo = data.value(forKey: "memo") as? String else { return }
                let imageModel = SavedImageViewModel(image: ImageModel(id: id, width: width, height: height, urls: ImageURL(small: urlString)), memo: memo)//ImageModel(id: id, width: width, height: height, urls: ImageURL(small: urlString))
                fetchDecodingCoredataArray.append(imageModel)
            }
            completion(fetchDecodingCoredataArray)
        } catch {
            print("fetching data error \(error.localizedDescription)")
        }
    }
    
    func saveImageInfo() {
        do {
            try context.save()
        } catch {
            print("saving context error \(error.localizedDescription)")
        }
    }
    
}
