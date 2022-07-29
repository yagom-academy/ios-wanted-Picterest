//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell, CellIdentifiable {
    // MARK: - UI Components
    private lazy var topView = ImageTopView()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(didLongPressCell(_:)))
        return gesture
    }()
    
    // MARK: - Properties
    var viewModel: PhotoListCollectionViewCellViewModel?
    
    // MARK: - Setup
    func setupView(photo: AAA, index: Int) {
        configUI()
        bindImage()
        topView.viewModel = viewModel?.imageTopViewModel
        if let photo = photo as? Photo {
            topView.setupView(text: "\(index)번째 사진")
            
            if viewModel?.checkSavedPhoto(photoID: photo.id) == true {
                topView.fillStarButton()
            }
            
        } else if let savedPhoto = photo as? CoreSavedPhoto {
            topView.setupView(text: savedPhoto.memo)
            topView.fillStarButton()
            contentView.addGestureRecognizer(longPressGesture)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        topView.initView()
    }
}

// MARK: - Bind
private extension PhotoListCollectionViewCell {
    func bindImage() {
        viewModel?.image.bind { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}

// MARK: - @objc Methods
private extension PhotoListCollectionViewCell {
    @objc func didLongPressCell(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            topView.didLongPress()
        }
    }
}

// MARK: - UI Methods
private extension PhotoListCollectionViewCell {
    func configUI() {
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        [
            topView,
            imageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        contentView.bringSubviewToFront(topView)
        
        NSLayoutConstraint.activate([
            topView
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor),
            topView
                .topAnchor
                .constraint(equalTo: contentView.topAnchor),
            topView
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor),
            
            imageView
                .leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor),
            imageView
                .topAnchor
                .constraint(equalTo: contentView.topAnchor),
            imageView
                .trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor),
            imageView
                .bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
}
