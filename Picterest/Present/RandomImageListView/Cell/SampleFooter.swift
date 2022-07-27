//
//  SampleFooter.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/26.
//

import UIKit

class SampleFooter: UICollectionReusableView, ReuseIdentifying {
    
    private let addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.backgroundColor = .yellow
    }
    
    private func layout() {
        
    }
}
