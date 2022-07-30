//
//  FeedCellView.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import UIKit

class FeedCollectionCustomCell: UICollectionViewCell {
    // MARK: - Properties
    var imageLoader: ImageLoader?
    private let cache = CacheService.shared
    static let identifier = String.FeedCellIdentifier
    
    // MARK: - View Properties
    var topButtonView: CellTopButtonView = {
        let CellTopButtonView = CellTopButtonView()
        return CellTopButtonView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        topButtonView.starButton.isSelected = false
        topButtonView.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        cancelLoad()
        super.prepareForReuse()
    }
}

// MARK: - Task Methods
extension FeedCollectionCustomCell {
    func setUpTask() {
        guard let imagePath = imageLoader?.configureURL()?.absoluteString else {
            return
        }
        if let imageData = cache.fetchData(imagePath) {
            let image = UIImage(data: imageData)
            self.imageView.image = image
            return
        }
        
        imageLoader?.requestNetwork(completion: { result in
            switch result {
            case .success(let data):
                
                let image = UIImage(data: data)
                self.cache.uploadData(key: imagePath, data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Error in download mage \(error)")
            }
        })
        
        imageLoader?.task?.resume()
    }
    
    func cancelLoad() {
        imageLoader?.cancelTask()
        imageView.image = nil
    }
}


// MARK: - UI Methods
private extension FeedCollectionCustomCell {
    func configureUI() {
        self.autoresizesSubviews = false
        
        [
            imageView,
            topButtonView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            topButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topButtonView.topAnchor.constraint(equalTo: self.topAnchor),
            topButtonView.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        imageView.frame = self.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        topButtonView.backgroundColor = .black.withAlphaComponent(0.2)
        topButtonView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
