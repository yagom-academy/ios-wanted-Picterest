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
    
    func fetchNewRandomImages()
    func randomImageAtIndex(index: Int) -> RandomImage
    func saveImageToStorage(image: UIImage, index: Int, memo: String)
    func deleteImageToStorage(index: Int)
}

final class RandomImageViewModel: RandomImageViewModelInterface {
    
    // MARK: - Properties
    let updateRandomImages = PassthroughSubject<Void, Never>()
    private let networkManager: NetworkManager
    private let storageManager: StorageManager
    private let coreDataManager: CoreDataManager
    private var lastIndex: Int = 0
    private var lastMemo: String = ""
    private var lastID: String = ""
    private var subscriptions = Set<AnyCancellable>()
    private var starImages = [StarImage]()
    private var currentTab: CurrentTab = .randomImage
    private var randomImages = [RandomImageEntity]() {
        didSet {
            updateRandomImages.send()
        }
    }
    var randomImagesCount: Int {
        randomImages.count
    }
    
    init(
        networkManager: NetworkManager,
        storageManager: StorageManager,
        coreDataManager: CoreDataManager
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        self.coreDataManager = coreDataManager
        bindingStorageManger()
        bindingCoreDataManager()
        configureCurrentTabNotification()
    }
}

// MARK: - Method
extension RandomImageViewModel {
    
    /// RandomImage 받아오기
    func fetchNewRandomImages() {
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
extension RandomImageViewModel {
    @objc private func currentTabNotificationAction(_ sender: Notification) {
        guard let currentTab = sender.userInfo?["currentTab"] as? CurrentTab else { return }
        self.currentTab = currentTab
    }
}

// MARK: - Storage
extension RandomImageViewModel {
    
    /// storage에 이미지 저장하기
    func saveImageToStorage(image: UIImage, index: Int, memo: String) {
        lastIndex = index
        lastMemo = memo
        let id = randomImages[index].id
        storageManager.saveImage(image: image, id: id)
    }
    
    /// 스토리지에서 이미지 삭제하기
    func deleteImageToStorage(index: Int) {
        let id = randomImages[index].id
        lastID = id
        storageManager.deleteImage(id: id)
    }
}

// MARK: - CoreData
extension RandomImageViewModel {
    private func saveImageInfoToCoreData(storageURL: String) {
        let randomImage = randomImages[lastIndex]
        let networkURLString = randomImage.urls.regularSizeImageURL
        let entity = StarImageEntity(
            id: randomImage.id,
            memo: lastMemo,
            networkURL: networkURLString,
            storageURL: storageURL,
            imageRatio: randomImage.imageRatio
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
                self?.updateRandomImages.send()
            }.store(in: &subscriptions)
    }
}
