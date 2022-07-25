//
//  PhotoListView.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class PhotoListView: UIView {

    let photoCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier)
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
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
        addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
