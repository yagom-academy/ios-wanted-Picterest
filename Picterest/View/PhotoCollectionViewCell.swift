//
//  PhotoCollectionViewCell.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PhotoCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension PhotoCollectionViewCell {
    func configureCell(_ photo: Photo) {
        
    }
}
