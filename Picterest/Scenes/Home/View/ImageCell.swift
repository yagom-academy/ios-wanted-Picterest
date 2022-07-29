//
//  ImageCell.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/25.
//

import UIKit

final class ImageCell: UICollectionViewCell {

  static let id = "ImageCell"
  
  private var model: ImageEntity? {
    didSet{
      guard let model = model else {return}
      let buttonImage = model.isLiked == true ? likeImage: defaultLikeImage
      self.imageView.setImage(urlSource: model){ image in
        model.saveImage(image: image)
      }
      if let memo = model.memo {
        memoLabel.text = memo
      }
      self.likeButton.setImage(buttonImage, for: .normal)
    }
  }
  
  var saveDidTap: ((ImageEntity) -> Void)?
  
  private let likeImage: UIImage? = {
    let image = UIImage(systemName: "star.fill")
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
    button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
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
  
  func configure(model: ImageEntity, indexPath: IndexPath) {
    self.memoLabel.text = "\(indexPath.item + 1)번째 사진"
    self.model = model
  }
  
  override func prepareForReuse() {
    imageView.image = nil
    memoLabel.text = nil
    likeButton.setImage(defaultLikeImage, for: .normal)
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
  
  @objc func saveButtonDidTap(){
    guard let model = self.model else {return}
    saveDidTap?(model)
  }
  
  func setLikeButtonToLike() {
    likeButton.setImage(likeImage, for: .normal)
  }
  
  func setLikeButtonToUndoLike() {
    likeButton.setImage(defaultLikeImage, for: .normal)
  }
  
}
