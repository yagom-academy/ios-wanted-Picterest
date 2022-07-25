//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "photoListCollectionViewCell"

    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var test: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(test)
        test.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            test.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            test.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
