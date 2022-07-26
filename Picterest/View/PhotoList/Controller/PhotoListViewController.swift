//
//  PhotoListViewController.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit
import Combine

class PhotoListViewController: BaseViewController {

    private let photoListView = PhotoListView()
    let photoListViewModel = PhotoListViewModel()
    
    var photoList : [Photo]?
    var disposalbleBag = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        self.view = photoListView
        configure()
        photoListView.photoCollectionView.dataSource = self
        photoListView.photoCollectionView.delegate = self
        photoListViewModel.getDataFromServer()
        setBinding()
        
    }
    
    func configure() {
        let layout = photoListView.photoCollectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
    }
}

extension PhotoListViewController {
    func setBinding() {
        self.photoListViewModel.$photoList.sink {[weak self] updatedPhotoList in
            self?.photoList = updatedPhotoList
            DispatchQueue.main.async {
                self?.photoListView.photoCollectionView.reloadData()
            }
        }.store(in: &disposalbleBag)
    }
}

extension PhotoListViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = photoListViewModel.makeImage(photoList?[indexPath.row].urls.small ?? "")
        cell.rightLabel.text = "\(indexPath.row + 1)번째 사진"
        
        return cell
    }
    
}

extension PhotoListViewController : CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(photoList?[indexPath.row].height ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(photoList?[indexPath.row].width ?? 0)
    }
    
}

extension PhotoListViewController : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (photoListView.photoCollectionView.contentOffset.y > (photoListView.photoCollectionView.contentSize.height - photoListView.photoCollectionView.bounds.size.height)) {
            beginBatchFetch()
        }
    }
    
    func beginBatchFetch() {
        DispatchQueue.main.async {
            self.photoListViewModel.getDataFromServer()
            self.photoListView.photoCollectionView.reloadData()
        }
    }
}
