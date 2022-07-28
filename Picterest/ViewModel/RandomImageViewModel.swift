//
//  RandomImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit
import Combine

protocol RandomImageViewModelInterface: AnyObject {
    var updateImages: PassthroughSubject<Void, Never> { get }
    var imagesCount: Int { get }
    
    func fetchNewRandomImages()
    func randomImageAtIndex(index: Int) -> RandomImage
    func saveImageToStorage(image: UIImage, index: Int, memo: String)
    func deleteImageToStorage(index: Int)
    func showImageSaveAlert(_ index: Int, button: UIButton, image: UIImage) -> UIAlertController
    func showImageDeleteAlert(_ index: Int, button: UIButton) -> UIAlertController
}

final class RandomImageViewModel: DefaultImageViewModel, RandomImageViewModelInterface {
    
    // MARK: - Properties
    private let networkManager: NetworkManager
    private var lastIndex: Int = 0
    private var lastMemo: String = ""
    private var lastID: String = ""
    private var subscriptions = Set<AnyCancellable>()
    private var starImages = [StarImage]()
    private var page: Int = 1

    init(
        networkManager: NetworkManager,
        storageManager: StorageManager,
        coreDataManager: CoreDataManager
    ) {
        self.networkManager = networkManager
        super.init(storageManager: storageManager, coreDataManager: coreDataManager)
        bindingStorageManger()
        bindingCoreDataManager()
        coreDataManager.getAllStarImages()
    }
}

// MARK: - Method
extension RandomImageViewModel {
    
    /// RandomImage 받아오기
    func fetchNewRandomImages() {
        let resource = Resource<[RandomImageEntity]>(
            params: [
                "count": "15",
                "page": "\(page)"
            ])
        networkManager.fetchRandomImageInfo(resource: resource)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(String(describing: error))
                case .finished :
                    break
                }
            } receiveValue: { [weak self] randomImages in
                self?.images.append(contentsOf: randomImages)
                self?.page += 1
            }.store(in: &subscriptions)
    }
    
    func randomImageAtIndex(index: Int) -> RandomImage {
        guard let randomImageEntity = images[index] as? RandomImageEntity else {
            return RandomImage(imageUrlString: "", imageRatio: 0, isStar: false)
        }
        var isStar: Bool
        if starImages.contains(where: { starImage in
            starImage.id == randomImageEntity.id
        }) {
            isStar = true
        } else {
            isStar = false
        }
        
        return RandomImage(
            imageUrlString: randomImageEntity.urls.regularSizeImageURL,
            imageRatio: randomImageEntity.imageRatio,
            isStar: isStar
        )
    }
    
    func showImageSaveAlert(_ index: Int, button: UIButton, image: UIImage) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "\(index)번째 사진을 저장하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let memo = alert.textFields?[0].text else { return }
            button.isSelected = true
            self?.saveImageToStorage(image: image, index: index, memo: memo)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        return alert
    }
    
    func showImageDeleteAlert(_ index: Int, button: UIButton) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "\(index)번째 사진을 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.deleteImageToStorage(index: index)
            button.isSelected = false
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}

// MARK: - Storage
extension RandomImageViewModel {
    
    /// storage에 이미지 저장하기
    func saveImageToStorage(image: UIImage, index: Int, memo: String) {
        guard let randomImageEntity = images[index] as? RandomImageEntity else {
            return
        }
        lastIndex = index
        lastMemo = memo
        let id = randomImageEntity.id
        storageManager.saveImage(image: image, id: id)
    }
    
    /// 스토리지에서 이미지 삭제하기
    func deleteImageToStorage(index: Int) {
        guard let randomImageEntity = images[index] as? RandomImageEntity else {
            return
        }
        let id = randomImageEntity.id
        lastID = id
        storageManager.deleteImage(id: id)
    }
}

// MARK: - CoreData
extension RandomImageViewModel {
    private func saveImageInfoToCoreData(storageURL: String) {
        guard let randomImageEntity = images[lastIndex] as? RandomImageEntity else {
            return
        }
        let networkURLString = randomImageEntity.urls.regularSizeImageURL
        let entity = StarImageEntity(
            id: randomImageEntity.id,
            memo: lastMemo,
            networkURL: networkURLString,
            storageURL: storageURL,
            imageRatio: randomImageEntity.imageRatio
        )
        
        coreDataManager.saveStarImages(entity: entity)
    }
    
    private func deleteImageInfoToCoreData() {
        let starImage = starImages.first {
            $0.id == lastID
        }
        guard let starImage = starImage else {
            return
        }
        
        coreDataManager.deleteStarImage(starImage: starImage)
    }
}

// MARK: - Binding
extension RandomImageViewModel {
    private func bindingStorageManger() {
        storageManager.saveSuccess
            .sink { [weak self] url in
                let urlString = url.absoluteString
                self?.saveImageInfoToCoreData(storageURL: urlString)
            }.store(in: &subscriptions)
        
        storageManager.deleteSuccess
            .sink { [weak self] in
                if self?.currentTab == .randomImage {
                    self?.deleteImageInfoToCoreData()
                }
            }.store(in: &subscriptions)
    }
    
    private func bindingCoreDataManager() {
        coreDataManager.getAllStarImageSuccess
            .sink { [weak self] starImages in
                self?.starImages = starImages
                self?.updateImages.send()
            }.store(in: &subscriptions)
    }
}
