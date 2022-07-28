//
//  StarImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/26.
//

import Combine
import UIKit

protocol StarImageViewModelInterface: AnyObject {
    var updateImages: PassthroughSubject<Void, Never> { get }
    var imagesCount: Int { get }
    
    func fetcnStarImages()
    func deleteImageToStorage(index: Int)
    func starImageAtIndex(index: Int) -> StarImage
    func showImageDeleteAlert(_ index: Int) -> UIAlertController 
}

final class StarImageViewModel: DefaultImageViewModel, StarImageViewModelInterface {
    
    // MARK: - Properties
    private var lastIndex: Int = 0
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
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
        guard let starImage = images[index] as? StarImage else { return StarImage() }
        return starImage
    }
    
    func showImageDeleteAlert(_ index: Int) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "사진을 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.deleteImageToStorage(index: index)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}

// MARK: - Storage
extension StarImageViewModel {
    
    /// 스토리지에서 이미지 삭제하기
    func deleteImageToStorage(index: Int) {
        guard let starImage = images[index] as? StarImage else { return }
        guard let id = starImage.id else { return }
        lastIndex = index
        storageManager.deleteImage(id: id)
    }
}

// MARK: - CoreData
extension StarImageViewModel {
    private func deleteImageInfoToCoreData() {
        guard let starImage = images[lastIndex] as? StarImage else { return }
        
        coreDataManager.deleteStarImage(starImage: starImage)
    }
}

// MARK: - Binding
extension StarImageViewModel {
    private func bindingCoreDataManager() {
        coreDataManager.getAllStarImageSuccess
            .sink { [weak self] starImages in
                self?.images = starImages
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

