//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//

import UIKit

protocol DidTapPhotoSaveButtonDelegate {
    func showSavePhotoAlert(isSelected: Bool, photoInfo: PhotoModel?, image: UIImage?)
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
        savedButton.setImage(UIImage(systemName: "star"), for: .normal)
        savedButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
    
    override func prepareForReuse() {
        radomImageView.image = nil
        savedButton.isSelected = false
    }
    
    @IBAction func didTapPhotoSave(_ sender: UIButton) {
        savedButton.isSelected.toggle()
        delegate?.showSavePhotoAlert(
            isSelected: savedButton.isSelected,
            photoInfo: photoInfo,
            image: radomImageView.image
        )
    }
    
    func fetchDataFromCollectionView(data: PhotoModel, isSelectedFlag: Bool) {
        if isSelectedFlag {
            savedButton.isSelected = true
        }
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
