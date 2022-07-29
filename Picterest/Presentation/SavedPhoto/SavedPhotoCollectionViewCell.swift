//
//  SavedPhotoCollectionViewCell.swift
//  Picterest
//
//  Created by BH on 2022/07/29.
//

import UIKit

class SavedPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIProperties
    
    private lazy var testView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    static let identifier: String = "SavedPhotoCollectionViewCell"
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Methods

    func setupCell() {
        testView.backgroundColor = .blue
    }
    
    private func setupView() {
        [testView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfImageView()
    }
    
    private func setupConstraintsOfImageView() {
        NSLayoutConstraint.activate([
            testView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            ),
            testView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor
            ),
            testView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor
            ),
            testView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
}
