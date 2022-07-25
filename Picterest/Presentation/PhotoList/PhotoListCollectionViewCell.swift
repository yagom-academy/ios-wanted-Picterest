//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell, CellIdentifiable {
    let la = UILabel()
    func setupView(index: Int) {
        contentView.backgroundColor = .red
        
        la.text = "\(index)"
        contentView.addSubview(la)
        la.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            la.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            la.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        la.text = nil
    }
}
