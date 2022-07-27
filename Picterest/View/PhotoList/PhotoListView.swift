//
//  PhotoListView.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class PhotoListView: UIView {
    
    let photoCollectionView : UICollectionView = {
        
        let layout = PhotoListCustomLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier)
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
        self.addSubview(photoCollectionView)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
