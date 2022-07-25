//
//  SavedImageListViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class SavedImageListViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        //temp
        view.backgroundColor = .blue
    }
    
    private func layout() {
        
    }
}
