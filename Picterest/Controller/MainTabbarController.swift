//
//  MainTabbarController.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

enum CurrentTab {
    case randomImage, starImage
}

final class MainTabbarController: UITabBarController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
    
    private func configureTabbar() {
        let networkManager = NetworkManager()
        let storageManager = StorageManager()
        let coreDataManager = CoreDataManager()
        
        let randomImageViewModel: RandomImageViewModelInterface = RandomImageViewModel(
            networkManager: networkManager,
            storageManager: storageManager,
            coreDataManager: coreDataManager
        )
        let starImageViewModel: StarImageViewModelInterface = StarImageViewModel(
            storageManager: storageManager,
            coreDataManager: coreDataManager
        )
        
        let randomImageVC = UINavigationController(
            rootViewController: RandomImageViewController(
                viewModel: randomImageViewModel))
        let starImageVC = UINavigationController(
            rootViewController: StarImageViewController(
                viewModel: starImageViewModel))
        
        randomImageVC.tabBarItem.title = "Images"
        randomImageVC.tabBarItem.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
        starImageVC.tabBarItem.title = "Saved"
        starImageVC.tabBarItem.image = UIImage(systemName: "star.bubble")
        
        tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .systemBackground
        
        setViewControllers([randomImageVC, starImageVC], animated: true)
        NotificationCenter.default.post(name: .currentTab, object: nil, userInfo: ["currentTab": CurrentTab.randomImage])
    }
}

extension MainTabbarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Images" {
            NotificationCenter.default.post(name: .currentTab, object: nil, userInfo: ["currentTab": CurrentTab.randomImage])
        } else {
            NotificationCenter.default.post(name: .currentTab, object: nil, userInfo: ["currentTab": CurrentTab.starImage])
        }
    }
}
