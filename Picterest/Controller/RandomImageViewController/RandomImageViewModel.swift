//
//  RandomImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation
import Combine

protocol RandomImageViewModelInterface: AnyObject {
    var updateRandomImages: PassthroughSubject<Void, Never> { get }
    var randomImagesCount: Int { get }
    
    func fetchNewImages()
    func randomImageAtIndex(index: Int) -> RandomImage
}

final class RandomImageViewModel: RandomImageViewModelInterface {
    
    // MARK: - Properties
    let networkManager = NetworkManager()
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
}
