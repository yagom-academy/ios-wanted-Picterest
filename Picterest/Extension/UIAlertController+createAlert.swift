//
//  UIAlertController+createAlert.swift
//  Picterest
//
//  Created by hayeon on 2022/07/27.
//

import UIKit
import CoreData

extension UIAlertController {
    
    func createAlert(_ title: String, _ message: String, style preferredStyle: UIAlertController.Style, hasTextField: Bool = false) -> UIAlertController {
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
        let actionHandler: (UIAlertAction) -> Void = { (action) -> Void in
            guard let textFields = self.textFields,
                  let memo = textFields[0].text,
                  let image = cell.view.imageView.image else {
                return
            }
            
            let id = imageInformation.id
            let originalURL = imageInformation.urls.small
            let imageHeight = imageInformation.height
            let imageWidth = imageInformation.width
            
            guard let savedLocation = ImageFileManager.shared.save(id as NSString, image) else {
                return
            }
            
            CoreDataManager.shared.save(id, originalURL, memo, savedLocation, imageHeight, imageWidth)
            cell.view.saveButton.setImage(UIImage(systemName: UIStyle.Icon.starFill), for: .normal)
            cell.view.saveButton.tintColor = .yellow
            cell.view.isSaved = true
        } 
        
        return actionHandler
    }
    
    func alertActionInSavedViewController(cell: SavedCollectionViewCell, imageData: NSManagedObject, completion: @escaping () -> Void) -> ((UIAlertAction) -> Void) {
        let imageFileManager = ImageFileManager.shared
        let coreDataManager = CoreDataManager.shared
        
        let actionHandler: (UIAlertAction) -> Void = { (action) -> Void in
            guard let id = imageData.value(forKey: CoreDataKey.id) as? NSString else {
                return
            }
            
            imageFileManager.remove(id)
            coreDataManager.remove(imageData)
            completion()
        }
        
        return actionHandler
    }
}
