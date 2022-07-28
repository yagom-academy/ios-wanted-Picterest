//
//  PhotoListViewController.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/25.
//

import UIKit
import Combine
import CoreData

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
        photoListViewModel.getDataFromCoreData()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoListView.photoCollectionView.reloadData()
    }
    
    func configure() {
        let layout = photoListView.photoCollectionView.collectionViewLayout as? PhotoListCustomLayout
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
        cell.index = indexPath.row
        updateStar(cell, (photoList?[indexPath.row].id) ?? "")
        cell.cellDelegate = self
        return cell
    }
    
    func updateStar(_ cell : PhotoListCollectionViewCell, _ name : String) {
        DispatchQueue.main.async {
            if (self.photoListViewModel.isSavedImage(name)) == false {
                cell.saveButton.setImage(UIImage(systemName: "star"), for: .normal)
                cell.saveButton.tintColor = .white
            } else {
                cell.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.saveButton.tintColor = .yellow
            }
        }
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

extension PhotoListViewController : SaveButtonDelegate {
    func pressSaveButton(_ cell : PhotoListCollectionViewCell) {
        if cell.saveButton.imageView?.image == UIImage(systemName: "star") {
            let alert = UIAlertController(title: "", message: "저장 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: {[weak self] _ in
                self?.dismiss(animated: true)
            }))
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { [weak self] _ in
                cell.memoText = alert.textFields?[0].text
                // filemanager에 이미지 저장
                guard let photo = self?.photoList?[cell.index ?? -1] else {return}
                guard let path = self?.photoListViewModel.saveImageToFilemanager(cell.imageView.image ?? UIImage(), photo.id) else {return}
                // coredata에 데이터 저장
                self?.photoListViewModel.saveDataToCoreData(photo.id, cell.memoText ?? "", photo.urls.small, path, Int32(photo.width), Int32(photo.height))
                cell.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.saveButton.tintColor = .yellow
            }))
            self.present(alert, animated: true)
        } else {
            cell.saveButton.setImage(UIImage(systemName: "star"), for: .normal)
            cell.saveButton.tintColor = .white
            // filemanager에 있는 이미지 삭제
            self.photoListViewModel.deleteImageFromFilemanager(self.photoList?[cell.index ?? -1].id ?? "")
            // coredata에 있는 정보 삭제
            CoreDataManager.shared.getData()
            for object in CoreDataManager.shared.images {
                if object.value(forKey: "id") as? String == photoList?[cell.index ?? -1].id ?? "" {
                    self.photoListViewModel.deleteDataInCoreData(object)
                }
            }
//            photoList?[cell.index ?? -1].id
        }
    }
}
