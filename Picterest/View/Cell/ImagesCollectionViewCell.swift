//
//  ImagesCollectionViewCell.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func alert(from cell: UICollectionViewCell)
}

final class ImagesCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?
    
    let view: CellView = {
        let view = CellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
        autoLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.isSaved = false
        view.textLabel.text = ""
        view.imageView.image = nil
        view.saveButton.isEnabled = true
        view.saveButton.setImage(UIImage(systemName: UIStyle.Icon.star), for: .normal)
        view.saveButton.tintColor = .white
    }
}

// MARK: - Public

extension ImagesCollectionViewCell {
    func configure(with imageInformation: ImageInformation, index: Int) {
        self.view.textLabel.text = "\(index + 1)번째 사진"
        self.view.imageView.loadImage(urlString: imageInformation.urls.small, imageID: imageInformation.id)
        
        if ImageFileManager.shared.fileExists(imageInformation.id as NSString) {
            self.view.saveButton.setImage(UIImage(systemName: UIStyle.Icon.starFill), for: .normal)
            self.view.saveButton.tintColor = .yellow
            self.view.isSaved = true
        }
    }
}

// MARK: - Private

extension ImagesCollectionViewCell {
    @objc private func tappedSaveImageButton() {
        if self.view.isSaved {
            return
        }
        delegate?.alert(from: self)
    }
    
    private func setView() {
        view.saveButton.addTarget(delegate, action: #selector(tappedSaveImageButton), for: .touchUpInside)
        self.addSubview(view)
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}


