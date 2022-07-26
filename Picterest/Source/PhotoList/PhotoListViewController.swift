//
//  PhotoListViewController.swift
//  Picterest
//
//

import UIKit

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    private var photoList: [PhotoModel] = []
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getPhotoData()
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
    
    func getPhotoData() {
        networkManager.getPhotoList { result in
            switch result {
            case .success(let data):
                self.photoList.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.photoListCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        print(photoList)
    }
}

//MARK: - Extension: CollectionView

extension PhotoListViewController: PhotoListCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let width = CGFloat(photoList[indexPath.row].width)
        let height = CGFloat(photoList[indexPath.row].height)
        return (((collectionView.frame.width - 32) / 2 ) - 10) * (height /  width)
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoList.count
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
        photoCell.fetchDataFromCollectionView(data: photoList[indexPath.row])
        photoCell.captionLabel.text = "\(indexPath.row)번째 사진"
        return photoCell
    }
}
