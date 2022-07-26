//
//  StarImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import Foundation
import Combine

protocol StarImageViewModelInterface {
    var updateStarImages: PassthroughSubject<Void, Never> { get }
}

final class StarImageViewModel: StarImageViewModelInterface {
    
    // MARK: - Properties
    let updateStarImages = PassthroughSubject<Void, Never>()
    private let storageManager = StorageManager()
    private let coreDataManager = CoreDataManager()
    private var subscriptions = Set<AnyCancellable>()
    private var starImages = [StarImage]() {
        didSet {
            updateStarImages.send()
        }
    }
    var starImageCount: Int {
        starImages.count
    }
    
    init() {
        bindingCoreDataManager()
    }
}

// MARK: - Method
extension StarImageViewModel {
    func fetcnStarImages() {
        coreDataManager.getAllStarImages()
    }
    
    func starImageAtIndex(index: Int) -> StarImage {
        return starImages[index]
    }
}

// MARK: - Binding
extension StarImageViewModel {
    private func bindingCoreDataManager() {
        coreDataManager.getAllStarImageSuccess
            .sink { [weak self] starImages in
                self?.starImages = starImages
            }.store(in: &subscriptions)
    }
}

