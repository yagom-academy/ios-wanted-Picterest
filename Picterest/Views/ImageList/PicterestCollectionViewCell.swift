//
//  PicterestCollectionViewCell.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

protocol PicterestPhotoSavable: AnyObject {
    func picterestCollectoinViewCell(isSelected: Bool, imageInfo: SavablePictureData, imageData: UIImage, idx: IndexPath)
}

final class PicterestCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PicterestPhotoSavable?
    
    private var currentImageInfo: SavablePictureData?
    private var currentImageData: UIImage?
    private var currentIndexPath: IndexPath?
    
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
        button.setImage(GlobalConstants.Image.PictureCell.nomal.image, for: .normal)
        button.setImage(GlobalConstants.Image.PictureCell.saved.image, for: .selected)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.starButton.isSelected = false
        self.picterestImageView.image = GlobalConstants.Image.PictureCell.photo.image
        self.indexTitleLabel.text = "n번째 사진"
    }
    
    private func setCellLayout() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
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
    
    func fetchImageData(data: SavablePictureData, at idx: IndexPath) {
        currentImageInfo = data
        currentIndexPath = idx
        ImageLoder().leadImage(url: data.imageData.imageUrl.smallUrl) { [self] result in
            switch result {
            case .success(let image):
                currentImageData = image
                picterestImageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        starButton.isSelected = data.isSaved
        indexTitleLabel.text = "\(idx.row)번째 사진"
    }
    
    func fetchImageDataToRepository(data: Picture) {
        starButton.isSelected = true
        starButton.isUserInteractionEnabled = false
        if let id = data.id {
            let imageUrl = PicterestFileManager.shared.getPictureLocaUrl(fileName: id)
            do {
                let imageData = try Data(contentsOf: imageUrl)
                picterestImageView.image = UIImage(data: imageData)
            } catch let error {
                print(error)
            }
        }
        
        indexTitleLabel.text = data.memo
    }
    
    private func setButtonAction() {
        starButton.addTarget(self, action: #selector(starbuttonClicked), for: .touchUpInside)
    }
    
    @objc func starbuttonClicked() {
        if let delegate = delegate {
            starButton.isSelected.toggle()
            guard let currentImageData = currentImageData, let currentImageInfo = currentImageInfo, let currentIndexPath = currentIndexPath else {
                return
            }
            delegate.picterestCollectoinViewCell(isSelected: starButton.isSelected, imageInfo: currentImageInfo, imageData: currentImageData, idx: currentIndexPath)
        }
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
