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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picterestLayout.delegate = self
        configureSubviews()
        imageCollectionViewModel.fetchImages()
        imageCollectionViewModel.collectionViewUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.picterestLayout.reloadData()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let imageData = imageCollectionViewModel.imageAtIndex(indexPath.row)
        cell.configureImageCollectionCell(with: imageData, index: indexPath.row)
        cell.starButtonTapped = { [weak self] (bool) in
            self?.starButtonTapped(didSave: bool, data: imageData)
        }
        return cell
    }
}

extension ImagesViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let yOffset = scrollView.contentOffset.y
        if yOffset > (contentHeight - frameHeight) {
            if imageCollectionViewModel.isFetching == false {
                imageCollectionViewModel.fetchImages(needToFetch: true)
            }
        }
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

extension ImagesViewController {
    func starButtonTapped(didSave: Bool, data: ImageViewModel) {
        let alert = UIAlertController(title: "사진 저장", message: "메모를 남겨보세요", preferredStyle: .alert)
        let save = UIAlertAction(title: "저장", style: .default) { _ in
            guard let textField = alert.textFields else { return }
            let text = textField[0].text
            DataManager.shared.save(data: data, memo: text ?? "")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(save)
        alert.addAction(cancel)
        alert.addTextField()
        present(alert, animated: true, completion: nil)
    }
}
