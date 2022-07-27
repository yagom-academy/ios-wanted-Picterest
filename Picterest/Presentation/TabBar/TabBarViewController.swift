//
//  TabBarViewController.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let networkRequester = NetworkRequester()
        let photoListProvider = PhotoListAPIProvider(networkRequester: networkRequester)
        let URLImageProvider = URLImageProvider(networkRequester: networkRequester)
        
        let photoListVC = PhotoListViewController.instantiate(with: photoListProvider, URLImageProvider)
        let photoListVCBarItem = Style.photoListTabBarItem
        let savedPhotoVC = SavedPhotoViewController()
        let savedPhotoVCBarItem = Style.savedPhotoTabBarItem
        
        photoListVC.tabBarItem = photoListVCBarItem
        savedPhotoVC.tabBarItem = savedPhotoVCBarItem
        
        self.viewControllers = [photoListVC, savedPhotoVC]
        
    }
    
}

// MARK: - NameSpaces

extension TabBarViewController {
    
    private enum Style {
        static let photoListTabBarItem: UITabBarItem = .init(
            title: "Images",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill")
        )
        static let savedPhotoTabBarItem: UITabBarItem = .init(
            title: "Favorites",
            image: UIImage(systemName: "star.square"),
            selectedImage: UIImage(systemName: "star.square.fill")
        )
    }
}
