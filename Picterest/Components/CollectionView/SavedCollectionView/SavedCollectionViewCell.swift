//
//  SavedCollectionViewCell.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/28.
//

import UIKit

class SavedCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var savedImageView: UIImageView!
    
    weak var viewController: UIViewController?
    private var cornerRadius: CGFloat = 15
    var deletImage : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        let longPressGesture = UILongPressGestureRecognizer()
        self.contentView.addGestureRecognizer(longPressGesture)
        longPressGesture.addTarget(self, action: #selector(cancleSaved))
    }
    
    
    @objc func cancleSaved() {
        viewController?.present(showCancleAlert(),animated: true)
    }
    
    @IBAction func savedButtonTap(_ sender: Any) {
        viewController?.present(showCancleAlert(),animated: true)
    }
    
    private func showCancleAlert() -> UIAlertController {
        let alert = UIAlertController(title: "사진 저장 취소", message: "사진을 저장을 취소하시겠습니까?", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "취소", style: .destructive)
        let accpetCancle = UIAlertAction(title: "확인", style: .default) { action in
            self.deletImage?()
        }
        
        alert.addAction(cancleAction)
        alert.addAction(accpetCancle)
        return alert
    }
}
