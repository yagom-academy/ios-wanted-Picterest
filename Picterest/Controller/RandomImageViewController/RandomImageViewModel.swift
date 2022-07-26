//
//  RandomImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit
import Combine

protocol RandomImageViewModelInterface: AnyObject {
    var updateRandomImages: PassthroughSubject<Void, Never> { get }
    var randomImagesCount: Int { get }
    
    func fetchNewImages()
    func randomImageAtIndex(index: Int) -> RandomImage
    func saveImage(image: UIImage, index: Int)
    func deleteImage(index: Int)
}

final class RandomImageViewModel: RandomImageViewModelInterface {
    
    // MARK: - Properties
    let networkManager = NetworkManager()
    let storageManager = StorageManager()
    let updateRandomImages = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    private var randomImages = [RandomImageEntity]() {
        didSet {
            updateRandomImages.send()
        }
    }
    var randomImagesCount: Int {
        randomImages.count
    }
    
    // MARK: - Method
    func fetchNewImages() {
        let resource = Resource<[RandomImageEntity]>()
        networkManager.fetchRandomImageInfo(resource: resource)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(String(describing: error))
                case .finished :
                    break
                }
            } receiveValue: { [weak self] images in
                self?.randomImages.append(contentsOf: images)
            }.store(in: &subscriptions)
    }
    
    func randomImageAtIndex(index: Int) -> RandomImage {
        let randomImageEntity = randomImages[index]
        
        return RandomImage(
            imageUrlString: randomImageEntity.urls.smallSizeImageURL,
            imageRatio: randomImageEntity.imageRatio
        )
    }
    
    func saveImage(image: UIImage, index: Int) {
        let id = randomImages[index].id
        storageManager.saveImage(image: image, id: id)
    }
    
    func deleteImage(index: Int) {
        let id = randomImages[index].id
        storageManager.deleteImage(id: id)
    }
}
