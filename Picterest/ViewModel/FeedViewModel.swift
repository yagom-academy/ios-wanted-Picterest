//
//  FeedViewModel.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import Combine
import UIKit
import CoreData

protocol FeedViewModelObservable: AnyObject {
    var isLoading: Bool { get set }
    var pageNumber: Int { get set }
    var imageDataLoader: NetWorkAble { get }
    var downLoadManager: DownLoadManager { get }
    var coreSavedImage: [savedModel] { get }
    var cancellable: Set<AnyCancellable> { get set }
}

class FeedViewModel: FeedViewModelObservable {
    private var coreDataService = CoreDataService.shared
    var coreSavedImage = [savedModel]()
    var downLoadManager = DownLoadManager.shared
    var isLoading: Bool = false
    var pageNumber: Int = 1
    @Published var imageDatas: Photo = []
    var imageDataLoader: NetWorkAble
    var cancellable = Set<AnyCancellable>()
    
    init(imageDataLoader: NetWorkAble) {
        self.imageDataLoader = imageDataLoader
        
        self.coreSavedImage = coreDataService.fetch()
    }
    
    func loadImageData() {
        isLoading = true
        
        imageDataLoader.requestNetwork() { result in
            switch result {
            case .success(let datas):
                if let photos = datas as? Photo {
                    self.imageDatas.append(contentsOf: photos)
                }
                self.isLoading = false
            case .failure(let error):
                print("Error in decode photo \(error)")
            }
        }
    }
    
    func saveImageInFile(index: Int, width: String, inputValue: String) {
        let data = imageDatas[index]
        let query = ["w":width]
        let imageLoader = ImageLoader(baseURL: data.urls.regular, query: query)
        
        imageLoader.requestNetwork { result in
            switch result {
            case .success(let image):
                if let image = image as? UIImage,
                   let imageData = image.pngData() {
                    let key = data.id.description + ".png"
                    
                    self.downLoadManager.uploadData(key: key, data: imageData)
                    self.coreDataService.save(
                        pictureId: data.id,
                        memo: inputValue, rawURL: data.urls.raw, fileLocation: key)
                    
                    
                }
            case .failure(_):
                print("Error in download image")
            }
        }
        
        imageLoader.task?.resume()
    }
}

private extension CoreDataService {
    @discardableResult
    func save(pictureId: String, memo: String, rawURL: String, fileLocation: String) -> Bool {
        let context = self.persistentContrainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "SavedModel", into: context)
        
        object.setValue(pictureId, forKey: "id")
        object.setValue(memo, forKey: "memo")
        object.setValue(rawURL, forKey: "rawURL")
        object.setValue(fileLocation, forKey: "fileURL")
        do {
            self.saveContext()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
}
