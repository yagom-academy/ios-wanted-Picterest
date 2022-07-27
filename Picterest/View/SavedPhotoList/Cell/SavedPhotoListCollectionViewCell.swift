//
//  SavedPhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//

import UIKit

class SavedPhotoListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "savedPhotoListCollectionViewCell"
        
    var saveButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .yellow
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
//        let tap = UITapGestureRecognizer(target: nil, action: #selector(pressButton(_:)))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tap)

        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.saveButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
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
            topStackView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
