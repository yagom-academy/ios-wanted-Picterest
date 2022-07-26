//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "photoListCollectionViewCell"

    var saveButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var rightLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    var topStackView: UIStackView = {
        let topView = UIStackView()
        topView.axis = .horizontal
        topView.backgroundColor = .gray
        topView.distribution = .equalSpacing
        topView.alpha = 0.6
        return topView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        [saveButton, rightLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topStackView.addArrangedSubview($0)
        }
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(topStackView)
        
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 5),
            saveButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),


            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
