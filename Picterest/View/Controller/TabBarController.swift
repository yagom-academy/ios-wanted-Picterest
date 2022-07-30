//
//  TabBarController.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/26.
//

import UIKit

final class TabBarController: UITabBarController {
    private lazy var imagesViewController: UIViewController = {
        let imagesVC = ImagesViewController()
        let tabBarItem = UITabBarItem(title: "Images",
                                      image: UIImage(systemName: "photo.on.rectangle"),
                                      selectedImage: nil)
        imagesVC.tabBarItem = tabBarItem
        return imagesVC
    }()
    
    private lazy var savedViewController: UIViewController = {
        let savedVC = SavedViewController()
        let tabBarItem = UITabBarItem(title: "Saved",
                                      image: UIImage(systemName: "star.bubble"),
                                      selectedImage: nil)
        savedVC.tabBarItem = tabBarItem
        return savedVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [imagesViewController, savedViewController]
    }
}
