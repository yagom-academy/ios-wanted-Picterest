//
//  RandomImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import Foundation
import Combine

final class RandomImageViewModel {
    // MARK: - Properties
    let networkManager = NetworkManager()
    let updateRandomImages = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    var randomImages = [RandomImage]() {
        didSet {
            updateRandomImages.send()
        }
    }
    
    // MARK: - Method
    func fetchNewImages() {
        let resource = Resource<[RandomImage]>()
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
}
