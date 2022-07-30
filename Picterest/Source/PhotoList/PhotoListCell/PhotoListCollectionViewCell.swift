//
//  PhotoListCollectionViewCell.swift
//  Picterest
//
//

import UIKit

protocol DidTapPhotoSaveButtonDelegate {
    func didTapPhotoSaveButton(isSelected: Bool, photoInfo: PhotoModel?, image: UIImage?)
}

class PhotoListCollectionViewCell: UICollectionViewCell, CellNamable {
    @IBOutlet weak var radomImageView: UIImageView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var delegate: DidTapPhotoSaveButtonDelegate?
    var photoInfo: PhotoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        savedButton.setImage(Icon.star.image, for: .normal)
        savedButton.setImage(Icon.starFill.image, for: .selected)
    }
    
    override func prepareForReuse() {
        radomImageView.image = nil
        savedButton.isSelected = false
    }
    
    @IBAction func didTapPhotoSave(_ sender: UIButton) {
        savedButton.isSelected.toggle()
        delegate?.didTapPhotoSaveButton(
            isSelected: savedButton.isSelected,
            photoInfo: photoInfo,
            image: radomImageView.image
        )
    }
    
    func fetchDataFromCollectionView(data: PhotoModel, isSelectedFlag: Bool) {
        if isSelectedFlag {
            savedButton.isSelected = true
        }
        ImageLoder().loadImage(url: data.urls.small) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.radomImageView.image = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
