//
//  BaseViewController.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        setupView()
    }
    
    func style() {
        view.backgroundColor = .white
    }
    
    func setupView() {}
}
