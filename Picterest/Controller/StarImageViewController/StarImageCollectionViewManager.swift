//
//  StarImageCollectionViewManager.swift
//  Picterest
//
//  Created by J_Min on 2022/07/28.
//

import UIKit
import Combine

final class StarImageCollectionViewManager: NSObject {
    
    // MARK: - Properties
    private let starImageViewModel: StarImageViewModelInterface
    let showAlert = PassthroughSubject<Int, Never>()
    
    // MARK: - LifeCycle
    init(viewModel: StarImageViewModelInterface) {
        self.starImageViewModel = viewModel
    }
    
    // MARK: - Method
    private func bindingCellStarButtonTapped(
        cell: ImageCollectionViewCell,
        index: Int
    ) {
        cell.starButtonTapped = { [weak self] _, _ in
            guard let self = self else { return }
            self.showAlert.send(index)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension StarImageCollectionViewManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starImageViewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let starImage = starImageViewModel.starImageAtIndex(index: indexPath.row)
        
        cell.configureCell(with: starImage)
        bindingCellStarButtonTapped(cell: cell, index: indexPath.row)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StarImageCollectionViewManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let starImage = starImageViewModel.starImageAtIndex(index: indexPath.row)
        let width = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right))
        let height = width * starImage.imageRatio
        return CGSize(width: width, height: height)
    }
}
