//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.tintColor = .lightGray
        
        return image
    }()
}
