//
//  ImagesViewController.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/26.
//

import UIKit

final class ImagesViewController: UIViewController {
    
    private let imageCollectionViewModel = ImageCollectionViewModel()
    private let picterestLayout = PicterestLayout()
    
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
        cell.starButtonStatusChanged = { [weak self] in
            self?.starButtonTapped(at: indexPath.row)
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
    private func starButtonTapped(at index: Int) {
        let data = imageCollectionViewModel.imageAtIndex(index)
        
        if imageCollectionViewModel.checkFileExistInLocal(data: data) {
            showAlertOfDelete(data: data)
        } else {
            showAlertOfSave(data: data)
        }
    }
    
    private func showAlertOfSave(data: ImageViewModel) {
        let alert = UIAlertController(title: "사진을 저장합니다 ", message: "메모를 남겨보세요", preferredStyle: .alert)
        let save = UIAlertAction(title: "저장", style: .default) { _ in
            guard let textField = alert.textFields,
                  let text = textField[0].text else { return }
            self.imageCollectionViewModel.save(data: data, with: text)
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(cancel)
        alert.addAction(save)
        alert.addTextField()
        present(alert, animated: true)
    }
    
    private func showAlertOfDelete(data: ImageViewModel) {
        let alert = UIAlertController(title: "즐겨찾기에서 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.imageCollectionViewModel.deleteImage(id: data.id)
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
}
