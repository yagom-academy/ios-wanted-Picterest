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
    var starImageCount: Int { get }
    
    func fetcnStarImages()
    func deleteImageToStorage(index: Int)
    func starImageAtIndex(index: Int) -> StarImage
}

final class StarImageViewModel: StarImageViewModelInterface {
    
    // MARK: - Properties
    let updateStarImages = PassthroughSubject<Void, Never>()
    private let storageManager: StorageManager
    private let coreDataManager: CoreDataManager
    private var lastIndex: Int = 0
    private var subscriptions = Set<AnyCancellable>()
    private var currentTab: CurrentTab = .randomImage
    private var starImages = [StarImage]() {
        didSet {
            updateStarImages.send()
        }
    }
    var starImageCount: Int {
        starImages.count
    }
    
    init(
        storageManager: StorageManager,
        coreDataManager: CoreDataManager
    ) {
        self.storageManager = storageManager
        self.coreDataManager = coreDataManager
        bindingCoreDataManager()
        bindingStorageManager()
        configureCurrentTabNotification()
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
    
    private func configureCurrentTabNotification() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(currentTabNotificationAction(_:)),
                name: .currentTab, object: nil
            )
    }
}

// MARK: - TargetMethod
extension StarImageViewModel {
    @objc private func currentTabNotificationAction(_ sender: Notification) {
        guard let currentTab = sender.userInfo?["currentTab"] as? CurrentTab else { return }
        self.currentTab = currentTab
    }
}

// MARK: - StorageManager
extension StarImageViewModel {
    
    /// 스토리지에서 이미지 삭제하기
    func deleteImageToStorage(index: Int) {
        guard let id = starImages[index].id else { return }
        lastIndex = index
        storageManager.deleteImage(id: id)
    }
}

// MARK: - CoreDataManager
extension StarImageViewModel {
    private func deleteImageInfoToCoreData() {
        let starImage = starImages[lastIndex]
        
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

