//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var radomImageView: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    func fetchDataFromCollectionView(data: PhotoModel) {
        ImageLoder().leadImage(url: data.urls.regular) { result in
            switch result {
            case .success(let photos):
                self.radomImageView.image = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
