//
//  TabViewController.swift
//  Picterest
//

import UIKit

class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedTabBarItem = UITabBarItem(title: "피드",
                                          image: UIImage(systemName: "photo.on.rectangle"),
                                          selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
        let savedTabBarItem = UITabBarItem(title: "즐겨찾기",
                                           image: UIImage(systemName: "star"),
                                           selectedImage: UIImage(systemName: "star.fill"))
        
        let feedController = FeedViewController()
        feedController.tabBarItem = feedTabBarItem
        
        let savedController = SavedViewController()
        savedController.tabBarItem = savedTabBarItem
        
        setViewControllers([feedController,savedController], animated: true)
        tabBar.backgroundColor = .lightGray
        
    }


}

