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

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var saveImageButton: UIButton!

    weak var delegate: ImageCollectionViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
    }
    
    @IBAction func tappedSaveImageButton(_ sender: UIButton) {
        delegate?.alert(from: self)
    }
}
