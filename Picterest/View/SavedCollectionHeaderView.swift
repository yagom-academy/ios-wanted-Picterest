//
//  SavedCollectionHeaderView.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/28.
//

import UIKit

class SavedCollectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SavedCollectionHeaderView"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.arrow.down")
        return imageView
    }()
    
    private lazy var label: UILabel =  {
        let label = UILabel()
        label.text = "Saved Images"
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    func configureView() {
        setSubView()
        setConstraints()
    }
    
    private func setSubView() {
        [imageView, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        setConstraintOfImageView()
        setConstraintOfLabel()
    }
    
    private func setConstraintOfImageView() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
    }
    
    private func setConstraintOfLabel() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
