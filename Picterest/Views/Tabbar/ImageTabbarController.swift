//
//  ImageTabbarController.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

class ImageTabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pictureListVC = ImageListViewController()
        let repositoryVC = ImageRepositoryViewController()
        let pictureNaviVC = UINavigationController(rootViewController: pictureListVC)
        let repositoryNaviVC = UINavigationController(rootViewController: repositoryVC)
        
        pictureListVC.navigationController?.navigationBar.prefersLargeTitles = true
        pictureListVC.navigationItem.largeTitleDisplayMode = .always
        repositoryVC.navigationController?.navigationBar.prefersLargeTitles = true
        repositoryVC.navigationItem.largeTitleDisplayMode = .always
        
        pictureListVC.title = "Picterest"
        repositoryVC.title = "Repository"
        
        let newsVCTabBarItem = UITabBarItem(title: "Images", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), tag: 1)
        pictureListVC.tabBarItem = newsVCTabBarItem
        
        let categoryVCTabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "star.bubble"), tag: 2)
        repositoryVC.tabBarItem = categoryVCTabBarItem

        self.viewControllers = [pictureNaviVC, repositoryNaviVC]

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
