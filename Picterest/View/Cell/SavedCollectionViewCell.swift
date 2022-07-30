//
//  SavedCollectionViewCell.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import UIKit
import CoreData

final class SavedCollectionViewCell: UICollectionViewCell {
    let view: CellView = {
        let view = CellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: CollectionViewCellDelegate?
    
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
        view.textLabel.text = ""
        view.imageView.image = nil
    }
}

// MARK: - Private

extension SavedCollectionViewCell {
    @objc private func longPressImageView() {
        delegate?.alert(from: self)
    }
    
    private func setView() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressImageView))
        view.imageView.isUserInteractionEnabled = true
        view.imageView.addGestureRecognizer(longPressGestureRecognizer)
        view.saveButton.setImage(UIImage(systemName: UIStyle.Icon.starFill), for: .normal)
        view.saveButton.tintColor = .yellow
        view.isSaved = true
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

extension SavedCollectionViewCell {
    func configure(with imageData: NSManagedObject) {
        guard let originalURL = imageData.value(forKey: CoreDataKey.originalURL) as? String,
              let imageID = imageData.value(forKey: CoreDataKey.id) as? String,
              var memo = imageData.value(forKey: CoreDataKey.memo) as? String else { return }
        
        if memo.count > 20 {
            memo = memo.padding(toLength: 20, withPad: " ", startingAt: 0)
            memo += "..."
        }

        self.view.imageView.loadImage(urlString: originalURL, imageID: imageID)
        self.view.textLabel.text = memo
    }
}
