//
//  TabBarController.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class TabBarController: UITabBarController {
    
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
        
        viewControllers = TabBar.allCases.map {
            switch $0 {
            case .photoList:
                let vc = PhotoListViewController(viewModel: viewModel.photoListViewModel)
                vc.tabBarItem = $0.tabBarItem
                return vc
            case .savedList:
                let vc = SavedListViewController(viewModel: viewModel.savedListViewModel)
                vc.tabBarItem = $0.tabBarItem
                return vc
            }
        }
    }
}
