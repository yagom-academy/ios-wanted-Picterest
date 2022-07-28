//
//  SavedViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

class SavedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCell", for: indexPath) as? SavedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.row

        cell.view.imageView.image = UIImage(systemName: "square")
        cell.view.textLabel.text = "\(index)번째 사진"
        cell.view.saveButton.tintColor = .white
        
        return cell
    }
}

extension SavedViewController: ImageCollectionViewCellDelegate {
    func alert(from cell: ImagesCollectionViewCell) {
        print("alert")
    }
    
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
//        flow.scrollDirection = .vertical
        return CGSize(width: 100, height: 100)
    }
}
