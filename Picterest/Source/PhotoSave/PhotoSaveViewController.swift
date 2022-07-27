//
//  PhotoSaveViewController.swift
//  Picterest
//
//

import UIKit

class PhotoSaveViewController: UIViewController {
    @IBOutlet weak var saveListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
}

//MARK: - Extension: CollectionView

extension PhotoSaveViewController {
    private func setCollectionView() {
        saveListCollectionView.dataSource = self
        saveListCollectionView?.contentInset = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
        saveListCollectionView.register(
            UINib(
                nibName: "PhotoSaveCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "PhotoSaveCollectionViewCell"
        )
        let flowlayout = UICollectionViewFlowLayout()
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let height: CGFloat = 300
        flowlayout.itemSize = CGSize(width: width, height: height)
        saveListCollectionView.collectionViewLayout = flowlayout
    }
}

extension PhotoSaveViewController: UICollectionViewDataSource {
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
        guard let saveCell = saveListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoSaveCollectionViewCell",
            for: indexPath
        ) as? PhotoSaveCollectionViewCell else {
            return UICollectionViewCell()
        }
        return saveCell
    }
}
