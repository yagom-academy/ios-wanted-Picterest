//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Type Properties
    
    static let identifier: String = "PhotoListCollectionViewCell"
    
    // MARK: - UIProperties
    
//    private lazy var testImage: UILabel = {
//        let label = UILabel()
//        label.text = "기본값"
//        return label
//    }()
    
    private lazy var testImage: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
}

// MARK: - Extensions

extension PhotoListCollectionViewCell {
    
    func setupCell(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.testImage.image = image
        }
    }
    
    private func setupView() {
        [testImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfTestImage()
    }
    
    private func setupConstraintsOfTestImage() {
        NSLayoutConstraint.activate([
            testImage.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: Style.padding
            ),
            testImage.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: Style.padding
            ),
            testImage.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: -Style.padding
            ),
            testImage.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: -Style.padding
            )
        ])
    }
    
}

// MARK: - NameSpaces

extension PhotoListCollectionViewCell {
    
    private enum Style {
        static let padding: CGFloat = 16
    }
}
