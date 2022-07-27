//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Type Properties
    
    static let identifier: String = "PhotoListCollectionViewCell"
    
    // MARK: - UIProperties
    
    private lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "기본값"
        return label
    }()
    
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
    
}

// MARK: - Extensions

extension PhotoListCollectionViewCell {
    
    func setupCell(photo: PhotoListResult) {
        testLabel.text = photo.id
    }
    
    private func setupView() {
        [testLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfTestLabel()
    }
    
    private func setupConstraintsOfTestLabel() {
        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: Style.padding
            ),
            testLabel.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: Style.padding
            )
        ])
    }
    
}

// MARK: - NameSpaces

extension PhotoListCollectionViewCell {
    
    private enum Style {
        static let padding: CGFloat = 16
    }
}
