//
//  PicterestCollectionViewCell.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

protocol PicterestPhotoSavable: AnyObject {
    func picterestCollectoinViewCell(imageData: ImageData)
}

class PicterestCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PicterestPhotoSavable?
    
    private var currentImageData: ImageData?
    
    private let picterestImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let cellTopBar: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return view
    }()
    
    private let starButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()
    
    private let indexTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "n번째 사진"
        label.textColor = .systemBackground
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellLayout()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCellLayout()
        setButtonAction()
    }
    
    private func setCellLayout() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.addSubview(picterestImageView)
        contentView.addSubview(cellTopBar)
        cellTopBar.addArrangedSubview(starButton)
        cellTopBar.addArrangedSubview(indexTitleLabel)
        
        NSLayoutConstraint.activate([
            picterestImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            picterestImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            picterestImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            picterestImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellTopBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellTopBar.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            cellTopBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellTopBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellTopBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setButtonAction() {
        starButton.addTarget(self, action: #selector(starbuttonClicked), for: .touchUpInside)
    }
    
    @objc func starbuttonClicked() {
        if let delegate = delegate {
            starButton.isSelected.toggle()
            delegate.picterestCollectoinViewCell(imageData: currentImageData!)
        }
    }
    
    func fetchImageData(data: ImageData, at n: Int) {
        currentImageData = data
        let imageData = try! Data(contentsOf: URL(string: data.imageUrl.smallUrl)!)
        let image = UIImage(data: imageData)!
        picterestImageView.image = image
        indexTitleLabel.text = "\(n)번째 사진"
    }
    
    private func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let scale = width / image.size.width
        let height = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
