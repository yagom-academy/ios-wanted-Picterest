//
//  FeedViewModel.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import Combine
import UIKit
import CoreData

protocol FeedViewModelAble: AnyObject {
    var isLoading: Bool { get }
    var imageDatas: Photo { get }
    var imageDataPublisher: Published<Photo>.Publisher { get }
    func fetchCoreData()
    func loadImageData()
    func coreImage() -> [savedModel]
    func saveImageInFile(index: Int, width: String, inputValue: String)
}

class FeedViewModel: FeedViewModelAble {
    private let downLoadManager = DownLoadManager()
    private var coreSavedImage = [savedModel]()
    private var imageDataLoader: NetWorkAble
    private var cancellable = Set<AnyCancellable>()
    
    @Published var imageDatas: Photo = []
    var imageDataPublisher: Published<Photo>.Publisher { $imageDatas }

    var isLoading: Bool = false
    
    init() {
        let endPoint = EndPoint(
            baseURL: "https://api.unsplash.com/photos",
            apiKey: KeyChainService.shared.key
        )
        
        self.imageDataLoader = ImageDataLoader(endPoint: endPoint)
        fetchCoreData()
    }
    
    func fetchCoreData() {
        self.coreSavedImage = CoreDataService.shared.fetch()
    }
    
    func loadImageData() {
        isLoading = true
        
        imageDataLoader.requestNetwork() { result in
            switch result {
            case .success(let datas):
                do {
                    let photos = try JSONDecoder().decode(Photo.self, from: datas)
                    self.imageDatas.append(contentsOf: photos)
                    self.isLoading = false
                } catch {
                    print("Error in decode image data")
                }
            case .failure(let error):
                print("Error in decode photo \(error)")
            }
        }
    }
    
    func saveImageInFile(index: Int, width: String, inputValue: String) {
        let data = imageDatas[index]
        let query = ["w":width]
        let endPoint = EndPoint(baseURL: data.urls.regular, query: query)
        let imageLoader = ImageLoader(endPoint: endPoint)
        
        imageLoader.requestNetwork { [weak self] result in
            switch result {
            case .success(let imageData):
                
                let key = data.id.description + ".png"
                
                if self?.downLoadManager.uploadData(key: key, data: imageData) == true {
                    CoreDataService.shared.save(
                        pictureId: data.id,
                        memo: inputValue,
                        rawURL: data.urls.raw,
                        fileLocation: key
                    )
                }

            case .failure(_):
                print("Error in download image")
            }
        }
    }
    
    func coreImage() -> [savedModel] {
        return coreSavedImage
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
