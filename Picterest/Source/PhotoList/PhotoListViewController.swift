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
        setCollectionView()
    }
}

//MARK: - Extension: Methods
extension PhotoListViewController {
    func setCollectionView() {
        photoListCollectionView.dataSource = self
        if let layout = photoListCollectionView.collectionViewLayout as?
            PhotoListCollectionViewLayout {
            layout.delegate = self
        }
        photoListCollectionView?.contentInset = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
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

extension PhotoListViewController: PhotoListCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        return 500
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let photoCell = photoListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoListCollectionViewCell",
            for: indexPath
        ) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        return photoCell
    }
}
