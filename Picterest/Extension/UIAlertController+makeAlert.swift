//
//  UIAlertController+makeAlert.swift
//  Picterest
//
//  Created by hayeon on 2022/07/27.
//

import UIKit

extension UIAlertController {
    
    func makeAlert(title: String, message: String, style preferredStyle: UIAlertController.Style, hasTextField: Bool = false) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if hasTextField {
            alertController.addTextField()
        }
        
        return alertController
    }
    
    func addAlertAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(alertAction)
    }
    
    func alertActionInImagesViewController(cell: ImagesCollectionViewCell, imageInformation: ImageInformation) -> ((UIAlertAction) -> Void) {
        
        let imageFileManager = ImageFileManager()
        
        let actionHandler: (UIAlertAction) -> Void = { (action) -> Void in
            guard let textFields = self.textFields,
                  let memo = textFields[0].text,
                  let image = cell.imageView.image else {
                return
            }
            
            let imageID = imageInformation.id
            let originalURL = imageInformation.urls.small
            
            guard let savedLocation = imageFileManager.saveImageToDevice(fileName: imageID, image) else {
                return
            }
            
            let imageCoreData = ImageCoreDataModel(id: imageID, memo: memo, originalURL: originalURL, savedLocation: savedLocation)
            
            CoreDataManager.shared.save(imageCoreData)
            cell.saveImageButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.saveImageButton.tintColor = .yellow
        }
        
        return actionHandler
    }
}
