//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    // MARK: - ViewProperties
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private lazy var descriptionView: ImageCollectionViewCellDescriptionView = {
        let view = ImageCollectionViewCellDescriptionView()
        view.starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Properties
    var starButtonTapped: ((UIButton, UIImage) -> Void)?
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubView()
        setConstraintsOfImageView()
        setConstraintsOfdescriptionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    // MARK: - Method
    func configureCell(with randomImage: RandomImage, index: Int) {
        self.imageView.load(randomImage.imageUrlString)
        descriptionView.configureView(index: index)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

// MARK: - TargetMethod
extension ImageCollectionViewCell {
    @objc private func starButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        starButtonTapped?(sender, image)
    }
}

// MARK: - UI
extension ImageCollectionViewCell {
    private func configureSubView() {
        [imageView, descriptionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setConstraintsOfImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setConstraintsOfdescriptionView() {
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
