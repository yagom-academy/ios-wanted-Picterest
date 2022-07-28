//
//  RandomImageCollectionViewManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/28.
//

import UIKit
import Combine

class RandomImageCollectionViewManager: NSObject {
    
    let randomImageViewModel: RandomImageViewModelInterface
    let showAlert = PassthroughSubject<UIAlertController, Never>()
    
    init(viewModel: RandomImageViewModelInterface) {
        self.randomImageViewModel = viewModel
    }
    
    private func bindingCellStarButtonTapped(
        cell: ImageCollectionViewCell,
        index: Int
    ) {
        cell.starButtonTapped = { [weak self] button, image in
            guard let self = self else { return }
            if button.isSelected {
                let alert = self.randomImageViewModel.showImageDeleteAlert(index, button: button)
                self.showAlert.send(alert)
            } else {
                let alert = self.randomImageViewModel.showImageSaveAlert(index, button: button, image: image)
                self.showAlert.send(alert)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RandomImageCollectionViewManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomImageViewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let randomImage = randomImageViewModel.randomImageAtIndex(index: indexPath.row)
        cell.configureCell(with: randomImage, index: indexPath.row)
        bindingCellStarButtonTapped(cell: cell, index: indexPath.row)
        
        return cell
    }
}

// MARK: - RandomImageCollectionViewLayoutDelegate
extension RandomImageCollectionViewManager: RandomImageCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        let height = width * (randomImageViewModel.randomImageAtIndex(index: indexPath.row).imageRatio)
        
        return height
    }
}

// MARK: - UICollectionViewDelegate
extension RandomImageCollectionViewManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == randomImageViewModel.imagesCount {
            randomImageViewModel.fetchNewRandomImages()
        }
    }
}
