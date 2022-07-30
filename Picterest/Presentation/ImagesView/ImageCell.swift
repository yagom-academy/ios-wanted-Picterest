//
//  ImageCell.swift
//  Picterest
//
//  Created by oyat on 2022/07/26.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func showAlert(imageID: String, index: IndexPath)
}

class ImageCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    weak var delegate: CollectionViewCellDelegate?
    
    private var cellimageUI: UIImage?
    private var cellimageID: String?
    private var cellindex: IndexPath?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        imageView.image = nil
    }
}

// MARK: - @objc Methods
extension ImageCell {
    @objc func tapStarButton() {
        //별이 비어있는 경우에만 다운 Alert 보여줌
        //별이 채워진 경우 Saved화면으로 이동 -> 삭제 Alert보여줌
        starButton.isSelected.toggle()
        guard let cellimageID = cellimageID,
              let cellindex = cellindex
        else { return }
        
        delegate?.showAlert(imageID: cellimageID, index: cellindex)
    }
}

// MARK: - Methods
extension ImageCell {
    func configure(index: IndexPath, data: ImagesViewModel.SaveData?) {
        cellindex = index
        guard let data = data else { return }
        let imageIndex = index.row + 1
        
        let image = imageView.load(urlString: data.imageURLString)
        print(image)
        let id = data.imageID
        cellimageID = id
        
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
