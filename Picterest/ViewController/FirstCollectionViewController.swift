//
//  FirstViewCollectionViewController.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import UIKit

class FirstCollectionViewController: UICollectionViewController {

    
    var imageListViewModel = ImageListViewModel()
    var numOfColumns = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? ImageCollectionViewLayout {
            layout.delegate = self
            layout.setNumberOfColumns(numOfColumns: 2)
            numOfColumns = layout.getNumberOfColumns()
        }
        
        imageListViewModel.fetchRandomImages()
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageListViewModel.collectionViewUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageListViewModel.getImageCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: imageListViewModel.imageViewModelAtIndexPath(index: indexPath.row), indexpath: indexPath.row)
        return cell
    }
}

extension FirstCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / CGFloat(numOfColumns)
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension FirstCollectionViewController: ImageCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right) ) / CGFloat(numOfColumns)
        let height = width*(imageListViewModel.imageList[indexPath.row].height / imageListViewModel.imageList[indexPath.row].width)
        
        return height
    }
    
}
