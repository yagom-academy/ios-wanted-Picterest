//
//  ImagesCollectionViewCell.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func alert(from cell: ImagesCollectionViewCell)
}

final class ImagesCollectionViewCell: UICollectionViewCell {
    
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
    
    weak var delegate: ImageCollectionViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.image = nil
        
    }
    
    @objc func tappedSaveImageButton() {
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
