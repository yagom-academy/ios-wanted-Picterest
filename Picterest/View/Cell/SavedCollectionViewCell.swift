//
//  SavedCollectionViewCell.swift
//  Picterest
//
//  Created by hayeon on 2022/07/28.
//

import UIKit

final class SavedCollectionViewCell: UICollectionViewCell {
    
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
    
    weak var delegate: CollectionViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.imageView.image = nil
        
    }
    
    private func setView() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressImageView))
        view.imageView.isUserInteractionEnabled = true
        view.imageView.addGestureRecognizer(longPressGestureRecognizer)
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
    
    @objc func longPressImageView() {
        delegate?.alert(from: self)
    }
}
