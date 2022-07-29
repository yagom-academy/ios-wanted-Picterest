//
//  SaveTableViewCell.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/27.
//

import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: ReusableCell {
        self.register(cellType, forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
}

class SaveTableViewCell: UITableViewCell, ReusableCell {
    
    let labelStackView = LabelStackView()
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    func fetchData(_ photo: SavePhoto) {
        layout()
        loadImage(photo)
    }
}

extension SaveTableViewCell {
    
    func layout() {
        labelStackView.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        [
            photoImageView, labelStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func loadImage(_ photo: SavePhoto) {
        LoadImage().loadImage(photo.originUrl!) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
