//
//  ImageCell.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func showAlert()
}

class ImageCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    weak var delegate: CollectionViewCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imageTopStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .black.withAlphaComponent(0.5)
        stackView.layer.cornerRadius = 30
        stackView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.addTarget(self, action: #selector(tapStarButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageNumberLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

// MARK: - @objc Methods
extension ImageCell {
    @objc func tapStarButton() {
        //별이 비어있는 경우에만 다운 Alert 보여줌
        //별이 채워진 경우 Saved화면으로 이동 -> 삭제 Alert보여줌
        starButton.isSelected.toggle()
        delegate?.showAlert()
    }
}

// MARK: - Methods
extension ImageCell {
    func configure(index: IndexPath, data: ImagesViewModel.ImageData?) {
        
        guard let data = data else { return }
        let imageIndex = index.row + 1
        imageView.load(urlString: data.imageURLString)
        imageNumberLabel.text = "\(imageIndex)번째 사진"
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.addSubview(imageTopStackView)
        NSLayoutConstraint.activate([
            imageTopStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageTopStackView.heightAnchor.constraint(equalToConstant: 50),
            imageTopStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageTopStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        imageTopStackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        imageTopStackView.isLayoutMarginsRelativeArrangement = true
        
        imageTopStackView.addArrangedSubview(starButton)
        imageTopStackView.addArrangedSubview(imageNumberLabel)
     
    }
}
