//
//  SecondCollectionViewController.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import UIKit
class SecondCollectionViewController: UICollectionViewController {
    
    var savedImageListViewModel = SavedImageListViewModel()
    var numOfColumns = 0

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
                print("reloadData")
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
        return cell
    }
    
    func configureRefreshControl() {
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        savedImageListViewModel.fetchSavedImageList()
        if let layout = collectionView.collectionViewLayout as? ImageCollectionViewLayout {
            layout.reloadData()
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
