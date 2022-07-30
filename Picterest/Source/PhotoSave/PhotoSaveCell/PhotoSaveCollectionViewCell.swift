//
//  PhotoSaveCollectionViewCell.swift
//  Picterest
//
//  Created by 효우 on 2022/07/27.
//

import UIKit

class PhotoSaveCollectionViewCell: UICollectionViewCell, CellNamable {
    
    var coreData = [Picterest]()
    
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var savedImageView: UIImageView!
    @IBOutlet weak var savedMemo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        savedImageView.image = nil
        savedMemo.text = nil
    }
    
    func fetchDataFromCollectionView(data: String) {
        ImageLoder().loadImage(url: data) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.savedImageView.image = photos
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
