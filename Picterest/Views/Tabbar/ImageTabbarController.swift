//
//  ImageTabbarController.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

final class ImageTabbarController: UITabBarController, UITabBarControllerDelegate {

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
        
        pictureListVC.title = GlobalConstants.Text.ViewController.imageListVC
        repositoryVC.title = GlobalConstants.Text.ViewController.imageRepositoryVC
        
        let pictureListTabBarItem = UITabBarItem(title: GlobalConstants.Text.TabbarItem.imageListVC, image: GlobalConstants.Image.Tabbar.photo.image, tag: 1)
        pictureListVC.tabBarItem = pictureListTabBarItem
        
        let repositoryTabBarItem = UITabBarItem(title: GlobalConstants.Text.TabbarItem.repositoryVC, image: GlobalConstants.Image.Tabbar.star.image, tag: 2)
        repositoryVC.tabBarItem = repositoryTabBarItem

        self.viewControllers = [pictureNaviVC, repositoryNaviVC]

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
