//
//  PhotoCollectionViewCell.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/26.
//

import UIKit

enum AcceptType {
    case saved
    case cancle
    case textField
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    weak var viewController: UIViewController?
    private var cornerRadius: CGFloat = 15
    var acceptSaveMemo: ((String) -> Void)?
    var cancleSaveImage: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        if sender.isSelected {
            viewController?.present(showAlert(operation: .cancle), animated: true)
        } else {
            viewController?.present(showAlert(operation: .saved), animated: true)
        }
    }
    
    func toggleSaveButton() {
        if saveButton.isSelected {
            saveButton.isSelected = false
            saveButton.tintColor = .white
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            saveButton.isSelected = true
            saveButton.tintColor = .yellow
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    func setButtonImage(isSaved: Bool) {
        if isSaved {
            saveButton.isSelected = true
            saveButton.tintColor = .yellow
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        } else {
            saveButton.isSelected = false
            saveButton.tintColor = .white
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    private func showSavedAlert() -> UIAlertController {
        let alert = UIAlertController(title: "사진 저장", message: "사진을 저장하시겠습니까?", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "취소", style: .destructive)
        let accpetSaved = UIAlertAction(title: "확인", style: .default) { action in
            self.viewController?.present(self.showAlert(operation: .textField), animated: true)
        }
        
        alert.addAction(cancleAction)
        alert.addAction(accpetSaved)
        return alert
    }
    
    private func showCancleAlert() -> UIAlertController {
        let alert = UIAlertController(title: "사진 저장 취소", message: "사진을 저장을 취소하시겠습니까?", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "취소", style: .destructive)
        let accpetCancle = UIAlertAction(title: "확인", style: .default) { action in
            self.toggleSaveButton()
            self.cancleSaveImage?()
        }
        
        alert.addAction(cancleAction)
        alert.addAction(accpetCancle)
        return alert
    }
    
    private func showTextFieldAlert() -> UIAlertController {
        let alert = UIAlertController(title: "메모 작성", message: "사진 저장을 위해 메모를 작성해주세요.", preferredStyle: .alert)
        
        let cancleAction = UIAlertAction(title: "취소", style: .destructive)
        let accpetSaveMemo = UIAlertAction(title: "확인", style: .default, handler: { action in
            if let memo = alert.textFields?.first?.text {
                self.toggleSaveButton()
                self.acceptSaveMemo?(memo)
            }
        })
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?.first, queue: .main) { notification in
            guard let textFieldText = alert.textFields?.first?.text else { return }
            accpetSaveMemo.isEnabled = !textFieldText.isEmpty
        }
        
        accpetSaveMemo.isEnabled = false
        alert.addAction(cancleAction)
        alert.addAction(accpetSaveMemo)
        
        alert.addTextField { texfield in
            texfield.placeholder = "메모를 작성해주세요."
        }
        
        return alert
    }
    
    func showAlert(operation: AcceptType) ->UIAlertController {
        switch operation {
        case .saved:
            return showSavedAlert()
        case .cancle:
            return showCancleAlert()
        case .textField:
            return showTextFieldAlert()
        }
    }
}
