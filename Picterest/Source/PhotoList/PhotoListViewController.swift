//
//  PhotoListViewController.swift
//  Picterest
//
//

import UIKit

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoListCollectionView.delegate = self
        photoListCollectionView.dataSource = self
        photoListCollectionView.register(
            UINib(
                nibName: "PhotoListCollectionViewCell",
                bundle: nil
                ),
                forCellWithReuseIdentifier: "PhotoListCollectionViewCell"
        )
    }
}

//MARK: - Extension: CollectionView

extension PhotoListViewController: UICollectionViewDelegate {
    
}


extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = photoListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoListCollectionViewCell",
            for: indexPath
        ) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        return photoCell
    }
    
    
}
