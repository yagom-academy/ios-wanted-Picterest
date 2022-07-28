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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSavedPhotosFromFilemanager()
        getImageDataFromCoreData()
        setBinding()
        // 저장된 이미지가 없을 때 coredata 초기화
        if savedPhotos?.isEmpty == true {
            CoreDataManager.shared.deleteAllData()
        }
        DispatchQueue.main.async {
            self.savedPhotoListView.savedPhotoCollectionView.reloadData()
        }
    }

    func getSavedPhotosFromFilemanager() {
        savedPhotoListViewModel.getSavedPhotoListFromFilemanager()
    }
    
    func getImageDataFromCoreData() {
        savedPhotoListViewModel.getDataFromCoreData()
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
        guard let height = CoreDataManager.shared.images[indexPath.row].value(forKey: "height")  as? CGFloat else {return 0}
        return height
//        return 100
//        코어데이터에서 꺼내오자
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
//        코어데이터에서 꺼내오자
        guard let width = CoreDataManager.shared.images[indexPath.row].value(forKey: "width")  as? CGFloat else {return 0}
        return width
//        return 100
    }
}

extension SavedPhotoListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedPhotoListCollectionViewCell.identifier, for: indexPath) as? SavedPhotoListCollectionViewCell else { return UICollectionViewCell() }
        let imageName = savedPhotos?[indexPath.row].split(separator: "/")[15] ?? ""
        cell.imageView.image = savedPhotoListViewModel.getSavedPhotoFromFilemanager(String(imageName))
        cell.index = indexPath.row
        cell.rightLabel.text = CoreDataManager.shared.images[indexPath.row].value(forKey: "memo") as? String
        cell.cellDelegate = self
        return cell
    }
}

extension SavedPhotoListViewController : ImageDelegate {
    func longPressImage(_ cell: SavedPhotoListCollectionViewCell) {
        let alert = UIAlertController(title: "", message: "삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: {[weak self] _ in
            self?.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "삭제", style: .default, handler: { [weak self] _ in
            // filemanager에 이미지 삭제
            let imageName = self?.savedPhotos?[cell.index ?? -1].split(separator: "/")[15] ?? ""
            self?.savedPhotoListViewModel.deleteImageFromFilemanager(String(imageName))
            // coredata에 데이터 삭제
            self?.savedPhotoListViewModel.deleteDataInCoreData(CoreDataManager.shared.images[cell.index ?? -1])
            // savedPhotos에서 삭제
            self?.savedPhotos?.remove(at: cell.index ?? -1)
            DispatchQueue.main.async {
                self?.savedPhotoListView.savedPhotoCollectionView.reloadData()
            }
        }))
        self.present(alert, animated: true)
    }
}
