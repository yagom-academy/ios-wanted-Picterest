//
//  SavedPhotoListViewController.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit
import Combine

class SavedPhotoListViewController: BaseViewController {

    private let savedPhotoListView = SavedPhotoListView()
    let savedPhotoListViewModel = SavedPhotoListViewModel()
    
    var savedPhotos : [String]?
    var disposalbleBag = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        self.view = savedPhotoListView
        configure()
        savedPhotoListView.savedPhotoCollectionView.dataSource = self
        savedPhotoListView.savedPhotoCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSavedPhotosFromFilemanager()
        setBinding()
        print(savedPhotos)
    }

    func getSavedPhotosFromFilemanager() {
        savedPhotoListViewModel.getSavedPhotoListFromFilemanager()
    }
    
    func configure() {
        let layout = savedPhotoListView.savedPhotoCollectionView.collectionViewLayout as? SavedPhotoListCustomLayout
        layout?.delegate = self
    }
}

extension SavedPhotoListViewController {
    func setBinding() {
        self.savedPhotoListViewModel.$savedPhotos.sink {[weak self] updatedSavedPhotoList in
            self?.savedPhotos = updatedSavedPhotoList
            DispatchQueue.main.async {
                self?.savedPhotoListView.savedPhotoCollectionView.reloadData()
            }
        }.store(in: &disposalbleBag)
    }
}

extension SavedPhotoListViewController : SavedCustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
//        return CGFloat(savedPhotos?[indexPath.row].height ?? 0)
//        코어데이터에서 꺼내오자
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
//        return CGFloat(savedPhotos?[indexPath.row].width ?? 0)
//        코어데이터에서 꺼내오자
        return 100
    }
    
}

extension SavedPhotoListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedPhotoListCollectionViewCell.identifier, for: indexPath) as? SavedPhotoListCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = savedPhotoListViewModel.getSavedPhotoFromFilemanager(savedPhotos?[indexPath.row] ?? "")
        return cell
    }
}

extension SavedPhotoListViewController : UICollectionViewDelegate {
    
}
