//
//  TabBarViewController.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let photoListViewController = PhotoListViewController()
        let savedPhotoListViewController = SavedPhotoListViewController()
        
        photoListViewController.title = "Images"
        savedPhotoListViewController.title = "Saved"
        
        photoListViewController.tabBarItem.image = UIImage(systemName: "photo.on.rectangle")
        savedPhotoListViewController.tabBarItem.image = UIImage(systemName: "star.bubble")

        let naviPhotoListController = UINavigationController(rootViewController: photoListViewController)
        let naviSavedPhotoLIstController = UINavigationController(rootViewController: savedPhotoListViewController)
        
        naviPhotoListController.isNavigationBarHidden = true
        naviSavedPhotoLIstController.isNavigationBarHidden = true
        
        setViewControllers([naviPhotoListController, naviSavedPhotoLIstController], animated: false)
    }
}
