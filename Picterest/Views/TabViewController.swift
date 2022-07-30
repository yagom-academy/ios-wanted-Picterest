//
//  TabViewController.swift
//  Picterest
//

import UIKit

class TabViewController: UITabBarController {
    
    private let feedTabBarItem = UITabBarItem(title: String.feed,
                                      image: UIImage.firstTabIcon,
                                      selectedImage: UIImage.firstTabTappedIcon)
    private let savedTabBarItem = UITabBarItem(title: String.saved,
                                       image: UIImage.secondTabIcon,
                                       selectedImage: UIImage.secondTabTappedIcon)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers(configureControllers(), animated: true)
    }
    
    func configureControllers() -> [UIViewController] {
        let feedController = FeedViewController(feedViewModel: FeedViewModel())
        let feedNavController = UINavigationController(rootViewController: feedController)
        
        feedController.tabBarItem = feedTabBarItem
        
        let savedController = SavedViewController(savedViewModel: SavedViewModel())
        savedController.tabBarItem = savedTabBarItem
        
        return [feedNavController,savedController]
    }
}
