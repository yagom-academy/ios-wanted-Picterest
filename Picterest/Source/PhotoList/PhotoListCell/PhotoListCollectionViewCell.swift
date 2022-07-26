//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//

import UIKit
protocol DidTapPhotoSaveButtonDelegate {
    func showSavePhotoAlert(sender: UIButton, photoInfo: PhotoModel?)
}

class PhotoListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var radomImageView: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    var delegate: DidTapPhotoSaveButtonDelegate?
    var photoInfo: PhotoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    @IBAction func didTapPhotoSave(_ sender: UIButton) {
        delegate?.showSavePhotoAlert(sender: sender, photoInfo: photoInfo)
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
