//
//  SecondCollectionViewController.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import UIKit
class SecondCollectionViewController: UICollectionViewController {
    
    let imageManager = ImageManager()
    var savedImageListViewModel = SavedImageListViewModel()
    var numOfColumns = 0
    var selectedIndexPath = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? ImageCollectionViewLayout {
            layout.delegate = self
            layout.setNumberOfColumns(numOfColumns: 1)
            numOfColumns = layout.getNumberOfColumns()
        }
        savedImageListViewModel.fetchSavedImageList()
        self.collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.secondViewIdentifier)
        savedImageListViewModel.collectionViewUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
        configureRefreshControl()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedImageListViewModel.getImageCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.secondViewIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configureSavedCell(with: savedImageListViewModel.imageViewModelAtIndexPath(index: indexPath.row), indexpath: indexPath.row)
        let longPressGesture: CustomLongPressTapGesture = CustomLongPressTapGesture(target: self, action: #selector(deleteImage(sender:)))
        longPressGesture.indexPath = indexPath.row
        cell.addGestureRecognizer(longPressGesture)
        return cell
    }
    
    @objc func deleteImage(sender: CustomLongPressTapGesture){
        
        let alert = UIAlertController(title: "이미지 삭제", message: "해당 이미지를 삭제하시겠습니까?", preferredStyle: .alert)
        let downloadAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.imageManager.deleteImage(savedImageViewModel: self.savedImageListViewModel.imageViewModelAtIndexPath(index: sender.indexPath ?? 0), indexPath: sender.indexPath ?? 0)
            self.refresh()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(downloadAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func configureRefreshControl() {
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        savedImageListViewModel.fetchSavedImageList()
        if let layout = collectionView.collectionViewLayout as? ImageCollectionViewLayout {
            layout.reloadData()
            self.collectionView.reloadData()
        }
        
    }
}

extension SecondCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / CGFloat(numOfColumns)
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension SecondCollectionViewController: ImageCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right) ) / CGFloat(numOfColumns)
        let height = width*(savedImageListViewModel.imageList[indexPath.row].height / savedImageListViewModel.imageList[indexPath.row].width)
        
        return height
    }
    
}

class CustomLongPressTapGesture: UILongPressGestureRecognizer {
    var indexPath: Int?
}
