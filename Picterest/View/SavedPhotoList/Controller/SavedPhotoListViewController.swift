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
        cell.index = indexPath.row
        cell.cellDelegate = self
        return cell
    }
}

extension SavedPhotoListViewController : UICollectionViewDelegate {
    
}

extension SavedPhotoListViewController : ImageDelegate {
    func longPressImage(_ cell: SavedPhotoListCollectionViewCell) {
        let alert = UIAlertController(title: "", message: "삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: {[weak self] _ in
            self?.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "삭제", style: .default, handler: { [weak self] _ in
            print("삭제")
            // filemanager에 이미지 삭제
            self?.savedPhotoListViewModel.deleteImageFromFilemanager(self?.savedPhotos?[cell.index ?? -1] ?? "")
            // coredata에 데이터 저장
            
            // savedPhotos에서 삭제
            self?.savedPhotos?.remove(at: cell.index ?? -1)
            DispatchQueue.main.async {
                self?.savedPhotoListView.savedPhotoCollectionView.reloadData()
            }
        }))
        self.present(alert, animated: true)
    }
}
