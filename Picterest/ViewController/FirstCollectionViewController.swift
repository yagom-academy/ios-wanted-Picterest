//
//  FirstViewCollectionViewController.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import UIKit

class FirstCollectionViewController: UICollectionViewController {

    
    var imageListViewModel = ImageListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.imageTitleOrIndexLabel.text = "\(indexPath.row)번째 사진"
        cell.configureCell(with: imageListViewModel.imageViewModelAtIndexPath(index: indexPath.row))
        return cell
    }
}

extension FirstCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        let size = CGSize(width: width, height: width)
        return size
    }
}
