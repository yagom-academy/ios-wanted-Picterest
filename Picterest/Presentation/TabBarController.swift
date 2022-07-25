//
//  TabBarController.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = TabBar.allCases.map { $0.viewController }
    }
}
