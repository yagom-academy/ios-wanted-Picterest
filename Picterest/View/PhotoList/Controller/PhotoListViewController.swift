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
    
    var photoList : PhotoList?
    var disposalbleBag = Set<AnyCancellable>()
    
    override func loadView() {
        self.view = photoListView
        photoListView.photoCollectionView.dataSource = self
        
        setBinding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        photoListView.photoCollectionView.dataSource = self
//
//        setBinding()
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitem: item,
            count: 3
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
//        cell.imageView.image = photoListViewModel.photoList[indexPath.row]
        cell.test.text = photoListViewModel.emojies[indexPath.row]
        
        return cell
    }
    
}
