//
//  FeedViewController.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import UIKit

class FeedViewController: UIViewController {
    let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = FeedViewModel(key: "")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        view.backgroundColor = .lightGray
    }
}



// MARK: - UI Configure Methods
private extension FeedViewController {
    func setUpNavBar() {
        navigationItem.title = "피드"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
}
