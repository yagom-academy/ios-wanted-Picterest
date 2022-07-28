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
    
    lazy var unsplashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.cornerRadius
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [starButton, memoLabel]
        )
        stackView.alpha = Style.alpha
        stackView.backgroundColor = .black
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Style.stackViewInsets
        return stackView
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(Style.starImage, for: .normal)
        button.setImage(Style.selectedStarImage, for: .selected)
        button.tintColor = .white
        button.addTarget(self,
                         action: #selector(tappedStarButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = "0번째 사진"
        label.textColor = .white
        return label
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
    
    // MARK: - @objc
    
    @objc func tappedStarButton(_ button: UIButton) {
        button.isSelected.toggle()
    }
    
}

// MARK: - Extensions

extension PhotoListCollectionViewCell {
    
    func setupImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.unsplashImageView.image = image
        }
    }
    
    func setupCell(photo: PhotoListResult, index: Int) {
        memoLabel.text = "\(index)번째 사진"
    }
    
    private func setupView() {
        [unsplashImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        unsplashImageView.addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [starButton,
         memoLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfUnsplashImageView()
        setupConstraintsOfTopStackView()
    }
    
    private func setupConstraintsOfUnsplashImageView() {
        NSLayoutConstraint.activate([
            unsplashImageView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor
            ),
            unsplashImageView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor
            ),
            unsplashImageView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor
            ),
            unsplashImageView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    private func setupConstraintsOfTopStackView() {
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(
                equalTo: unsplashImageView.safeAreaLayoutGuide.leadingAnchor
            ),
            topStackView.topAnchor.constraint(
                equalTo: unsplashImageView.safeAreaLayoutGuide.topAnchor
            ),
            topStackView.trailingAnchor.constraint(
                equalTo: unsplashImageView.safeAreaLayoutGuide.trailingAnchor
            ),
            topStackView.heightAnchor.constraint(equalToConstant: Style.stackViewHeight)
        ])
    }
    
    private func setupConstraintsOfStarButton() {
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(
                equalTo: topStackView.safeAreaLayoutGuide.topAnchor
            ),
            starButton.leadingAnchor.constraint(
                equalTo: topStackView.leadingAnchor
            )
        ])
    }
    
    private func setupConstraintsOfMemoLabel() {
        NSLayoutConstraint.activate([
            memoLabel.topAnchor.constraint(
                equalTo: topStackView.safeAreaLayoutGuide.topAnchor
            ),
            memoLabel.trailingAnchor.constraint(
                equalTo: topStackView.trailingAnchor
            )
        ])
    }
    
}

// MARK: - NameSpaces

extension PhotoListCollectionViewCell {
    
    private enum Style {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 10
        static let alpha: CGFloat = 0.6
        static let stackViewHeight: CGFloat = 40
        
        static let starImage = UIImage(systemName: "star")
        static let selectedStarImage = UIImage(systemName: "star.fill")
        static let stackViewInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
    }
}
