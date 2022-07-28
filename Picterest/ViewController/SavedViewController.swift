//
//  SavedViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

class SavedViewController: UIViewController, ImageCollectionViewCellDelegate {
    func alert(from cell: ImagesCollectionViewCell) {
        print("alert")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//extension SavedViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCell", for: indexPath) as? ImagesCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        cell.delegate = self
//        cell.customView.imageView.image = UIImage(systemName: "star.fill")
//        cell.customView.textLabel.text = "메모"
//        cell.customView.saveButton.tintColor = .red
//        return cell
//    }
//}
