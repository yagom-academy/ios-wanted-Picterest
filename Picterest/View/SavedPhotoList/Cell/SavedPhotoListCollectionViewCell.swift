//
//  SavedPhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/27.
//

import UIKit

protocol ImageDelegate : AnyObject {
    func longPressImage(_ cell : SavedPhotoListCollectionViewCell)
}

class SavedPhotoListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "savedPhotoListCollectionViewCell"
    
    weak var cellDelegate : ImageDelegate?
    
    var index : Int?

    let saveButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    let rightLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let topStackView: UIStackView = {
        let topView = UIStackView()
        topView.axis = .horizontal
        topView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        topView.distribution = .equalSpacing
        topView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        topView.isLayoutMarginsRelativeArrangement = true
        return topView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(longPressImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func longPressImage() {
        cellDelegate?.longPressImage(self)
    }
    
    // MARK: Setup
    
    private func setupView() {
        
        [saveButton, rightLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topStackView.addArrangedSubview($0)
        }
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(topStackView)
        
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: AutoLayout
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
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
