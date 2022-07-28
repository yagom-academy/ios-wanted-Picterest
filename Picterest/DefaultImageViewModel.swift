//
//  DefaultImageViewModel.swift
//  Picterest
//
//  Created by J_Min on 2022/07/28.
//

import UIKit
import Combine

class DefaultImageViewModel {
    let updateImages = PassthroughSubject<Void, Never>()
    let storageManager: StorageManager
    let coreDataManager: CoreDataManager
    var currentTab: CurrentTab = .randomImage
    var images: [Image] = [Image]() {
        didSet {
            updateImages.send()
        }
    }
    var imagesCount: Int {
        images.count
    }
    
    init(
        storageManager: StorageManager,
        coreDataManager: CoreDataManager
    ) {
        self.storageManager = storageManager
        self.coreDataManager = coreDataManager
        configureCurrentTabNotification()
    }
    
    deinit {
        NotificationCenter
            .default
            .removeObserver(self, name: .currentTab, object: nil)
    }
}

// MARK: - Method
extension DefaultImageViewModel {
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
extension DefaultImageViewModel {
    @objc private func currentTabNotificationAction(_ sender: Notification) {
        guard let currentTab = sender.userInfo?["currentTab"] as? CurrentTab else { return }
        self.currentTab = currentTab
    }
}
