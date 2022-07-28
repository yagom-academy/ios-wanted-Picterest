//
//  StarImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import Foundation
import Combine

protocol StarImageViewModelInterface {
    var updateImages: PassthroughSubject<Void, Never> { get }
    var starImageCount: Int { get }
    
    func fetcnStarImages()
    func deleteImageToStorage(index: Int)
    func starImageAtIndex(index: Int) -> StarImage
}

final class StarImageViewModel: DefaultImageViewModel, StarImageViewModelInterface {
    
    // MARK: - Properties
    private var lastIndex: Int = 0
    private var subscriptions = Set<AnyCancellable>()
    private var starImages: [Image] = [StarImage]() {
        didSet {
            updateImages.send()
        }
    }
    var starImageCount: Int {
        starImages.count
    }
    
    override init(
        storageManager: StorageManager,
        coreDataManager: CoreDataManager
    ) {
        super.init(storageManager: storageManager, coreDataManager: coreDataManager)
        bindingCoreDataManager()
        bindingStorageManager()
    }
}

// MARK: - Method
extension StarImageViewModel {
    func fetcnStarImages() {
        coreDataManager.getAllStarImages()
    }
    
    func starImageAtIndex(index: Int) -> StarImage {
        guard let starImage = starImages[index] as? StarImage else { return StarImage() }
        return starImage
    }
}

// MARK: - StorageManager
extension StarImageViewModel {
    
    /// 스토리지에서 이미지 삭제하기
    func deleteImageToStorage(index: Int) {
        guard let starImage = starImages[index] as? StarImage else { return }
        guard let id = starImage.id else { return }
        lastIndex = index
        storageManager.deleteImage(id: id)
    }
}

// MARK: - CoreDataManager
extension StarImageViewModel {
    private func deleteImageInfoToCoreData() {
        guard let starImage = starImages[lastIndex] as? StarImage else { return }
        
        coreDataManager.deleteStarImage(starImage: starImage)
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
    
    private func bindingStorageManager() {
        storageManager.deleteSuccess
            .sink { [weak self] in
                if self?.currentTab == .starImage {             
                    self?.deleteImageInfoToCoreData()
                }
            }.store(in: &subscriptions)
    }
}

