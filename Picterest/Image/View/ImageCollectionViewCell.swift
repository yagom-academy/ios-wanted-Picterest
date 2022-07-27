//
//  ImageCollectionViewCell.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit
import CoreData

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private var indexPath: IndexPath?
    private let ImageVC = ImageViewController()
    let labelStackView = LabelStackView()
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    func fetchData(_ photo: Photo, _ indexPath: IndexPath) {
        layout()
        loadImage(photo)
        
        self.indexPath = indexPath
        labelStackView.photoLabel.text = "\(indexPath.row)번째 사진"
    }
}

extension ImageCollectionViewCell {
    
    private func layout() {
        [
            photoImageView, labelStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func loadImage(_ photo: Photo) {
        LoadImage().loadImage(photo.urls.small) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ImageCollectionViewCell {
    
    func asdf() {
        guard let row = indexPath?.row else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavePhoto", in: context)
        
        if let entity = entity {
            let savePhoto = NSManagedObject(entity: entity, insertInto: context)
            savePhoto.setValue(ImageVC.photoList[row].id, forKey: "id")
            savePhoto.setValue("", forKey: "memo")
            savePhoto.setValue(ImageVC.photoList[row].urls.small, forKey: "originUrl")
            savePhoto.setValue("", forKey: "location")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
