//
//  SavedPhotoListView.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class SavedPhotoListView: UIView {

    let savedPhotoCollectionView : UICollectionView = {
        
        let layout = SavedPhotoListCustomLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SavedPhotoListCollectionViewCell.self, forCellWithReuseIdentifier: SavedPhotoListCollectionViewCell.identifier)
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
        self.addSubview(savedPhotoCollectionView)
        savedPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            savedPhotoCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            savedPhotoCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            savedPhotoCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            savedPhotoCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
