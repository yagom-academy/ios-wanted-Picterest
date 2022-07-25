//
//  MainTabBarController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setVC()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.init(red: 110/256, green: 77/256, blue: 65/256, alpha: 1)
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        self.tabBar.tintColor = .white

    }
    
    private func setVC() {
        let vc1 = RandomImageListViewController()
        vc1.tabBarItem.image = UIImage(systemName: "photo.fill.on.rectangle.fill")

        let vc2 = SavedImageListViewController()
        vc2.tabBarItem.image = UIImage(systemName:  "star.bubble")

        self.viewControllers = [vc1, vc2]
    }

}
