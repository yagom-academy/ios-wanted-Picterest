//
//  ImageCell.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

final class ImageCell: UICollectionViewCell {

  static let id = "ImageCell"
  
  private let likeImage: UIImage? = {
    let image = UIImage(systemName: "star.fil")
    return image
  }()
  
  private let defaultLikeImage: UIImage? = {
    let image = UIImage(systemName: "star")
    return image
  }()
  
  private lazy var likeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.tintColor = .white
    button.setImage(defaultLikeImage, for: .normal)
    return button
  }()
  
  private let memoLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = .clear
    label.font = .systemFont(ofSize: 17, weight: .medium)
    return label
  }()
  
  private lazy var labelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [likeButton, memoLabel])
    stackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    stackView.spacing = UIStackView.spacingUseSystem
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraints()
    layer.cornerRadius = 15
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(model: ImageEntity) {
    self.imageView.setImage(url: model.imageURL){ image in
      model.saveImage(image: image)
    }
    memoLabel.text = model.memo
  }
  
  override func prepareForReuse() {
    imageView.image = nil
    
  }

}

private extension ImageCell {
  
  func setConstraints() {
    
    contentView.addSubview(imageView)
    contentView.addSubview(labelStackView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      labelStackView.heightAnchor.constraint(equalToConstant: 50),
      labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
    
  }
  
}
