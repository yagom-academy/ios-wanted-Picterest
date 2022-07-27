//
//  ImagesViewController.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/26.
//

import UIKit

class ImagesViewController: UIViewController {
    
    let imageCollectionViewModel = ImageCollectionViewModel()
    let picterestLayout = PicterestLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: picterestLayout)
        collectionView.register(imagesCollectionViewCell.self,
                                forCellWithReuseIdentifier: imagesCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picterestLayout.delegate = self
        collectionView.dataSource = self
        configureSubviews()
        imageCollectionViewModel.fetchImages()
        imageCollectionViewModel.collectionViewUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configureSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionViewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCollectionViewCell.reuseIdentifier, for: indexPath) as? imagesCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: imageCollectionViewModel.imageAtIndex(indexPath.row), index: indexPath.row)
        return cell
    }
}

extension ImagesViewController: PicterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageViewModel = imageCollectionViewModel.imageAtIndex(indexPath.row)
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageRatio = CGFloat(imageViewModel.height) / CGFloat(imageViewModel.width)
        return cellWidth * imageRatio
    }
}
