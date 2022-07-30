//
//  TabBarController.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let viewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = TabBarCase.allCases.map {
            switch $0 {
            case .photoList:
                let viewController = PhotoListViewController(
                    viewModel: viewModel.photoListViewModel
                )
                viewController.tabBarItem = $0.tabBarItem
                return viewController
            case .savedList:
                let viewController = SavedListViewController(
                    viewModel: viewModel.savedListViewModel
                )
                viewController.tabBarItem = $0.tabBarItem
                let navigationViewController = UINavigationController(
                    rootViewController: viewController
                )
                return navigationViewController
            }
        }
    }
}
