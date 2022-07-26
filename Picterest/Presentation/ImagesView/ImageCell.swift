//
//  ImageCell.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import UIKit

class ImageCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods
extension ImageCell {
    func configure(data: ImagesViewModel.ImageData?) {
        
        guard let data = data else { return }
        imageView.load(urlString: data.imageURLString)
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
