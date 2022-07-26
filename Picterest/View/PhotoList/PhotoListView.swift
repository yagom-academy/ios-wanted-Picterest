//
//  PhotoListView.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class PhotoListView: UIView {

    let photoCollectionView : UICollectionView = {
        
        let layout = CustomLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier)
        collectionView.layer.borderWidth = 1
        return collectionView
    }()
    
    let navigationBottomBar : UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let navItem = UINavigationItem(title: "SomeTitle")

        navigationBar.setItems([navItem], animated: false)
        return navigationBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.addSubview(navigationBottomBar)
        self.addSubview(photoCollectionView)
        navigationBottomBar.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            navigationBottomBar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            navigationBottomBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
