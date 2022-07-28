//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit

protocol SaveButtonDelegate : AnyObject {
    func pressSaveButton(_ cell : PhotoListCollectionViewCell)
}

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "photoListCollectionViewCell"
    
    weak var cellDelegate : SaveButtonDelegate?
    var index : Int?
    var memoText : String?
    
    var saveButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .highlighted)
        button.tintColor = .white
        return button
    }()
    
    var rightLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var topStackView: UIStackView = {
        let topView = UIStackView()
        topView.axis = .horizontal
        topView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        topView.distribution = .equalSpacing
        topView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        topView.isLayoutMarginsRelativeArrangement = true
        return topView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: nil, action: #selector(pressButton(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.saveButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        cellDelegate?.pressSaveButton(self)
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
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topStackView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
