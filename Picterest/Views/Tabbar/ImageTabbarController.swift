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
        
        let newsVC = ImageListViewController()
        let categoryVC = ImageRepositoryViewController()
        
        let newsVCTabBarItem = UITabBarItem(title: "Images", image: UIImage(systemName: "photo.fill.on.rectangle.fill"), tag: 1)
        newsVC.tabBarItem = newsVCTabBarItem
        
        let categoryVCTabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "star.bubble"), tag: 2)
        categoryVC.tabBarItem = categoryVCTabBarItem

        self.viewControllers = [newsVC, categoryVC]

    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
