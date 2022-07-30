//
//  SavedImageCell.swift
//  Picterest
//
//  Created by oyat on 2022/07/29.
//

import Foundation
import UIKit

class SavedImageCell: UICollectionViewCell, ReuseIdentifying {
    
    private let savedImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var savedImageTopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .black.withAlphaComponent(0.5)
        return stackView
    }()
    
    private lazy var savedImageStarButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var savedMemoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "asdfasdfasdf"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Methods
extension SavedImageCell {
    func configure() {
        
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 30
        contentView.clipsToBounds = true
        
        contentView.addSubview(savedImageView)
        NSLayoutConstraint.activate([
            savedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            savedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            savedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            savedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(savedImageTopStackView)
        NSLayoutConstraint.activate([
            savedImageTopStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            savedImageTopStackView.heightAnchor.constraint(equalToConstant: 50),
            savedImageTopStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            savedImageTopStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        savedImageTopStackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        savedImageTopStackView.isLayoutMarginsRelativeArrangement = true
        
        savedImageTopStackView.addArrangedSubview(savedImageStarButton)
        savedImageTopStackView.addArrangedSubview(savedMemoLabel)
    }
}
