//
//  UIAlertController+makeAlert.swift
//  Picterest
//
//  Created by hayeon on 2022/07/27.
//

import UIKit
import CoreData

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
        
        let imageFileManager = ImageFileManager.shared
        let coreDataManager = CoreDataManager.shared
        
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
            
            guard let savedLocation = imageFileManager.save(id as NSString, image) else { return }
            
            coreDataManager.save(id: id, originalURL: originalURL, memo: memo, savedLocation: savedLocation, imageHeight: imageHeight, imageWidth: imageWidth)
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
            
            guard let savedLocation = imageData.value(forKey: CoreDataKey.savedLocation) as? String else { return }
            print("savedLocation: \(savedLocation)")
            imageFileManager.removeItem(at: savedLocation)
            coreDataManager.remove(imageData)
            completion()
            print("remove success")
        }
        
        return actionHandler
    }
}
