//
//  ImagesViewController.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/26.
//

import UIKit

final class ImagesViewController: UIViewController {
    
    private let viewModel = ImageCollectionViewModel()
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
        viewModel.fetchImages()
        viewModel.collectionViewUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.picterestLayout.reloadData()
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.collectionViewUpdate = { [weak self] in
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
        return viewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let imageData = viewModel.image(at: indexPath.row)
        cell.configureImageCollectionCell(with: imageData, at: indexPath.row) 
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
            if viewModel.isFetching == false {
                viewModel.fetchImages(needToFetch: true)
            }
        }
    }
}

extension ImagesViewController: PicterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageData = viewModel.image(at: indexPath.row)
        let cellWidth: CGFloat = view.bounds.width / 2
        let imageRatio = CGFloat(imageData.image.height) / CGFloat(imageData.image.width)
        return cellWidth * imageRatio
    }
}

extension ImagesViewController {
    private func starButtonTapped(at index: Int) {
        
        let data = viewModel.image(at: index)
        
        if data.isSaved {
            showAlertOfDelete(data)
        } else {
            showAlertOfSave(data)
        }
    }
    
    private func showAlertOfSave(_ data: ImageData) {
        let alert = UIAlertController(title: "사진을 저장합니다 ", message: "메모를 남겨보세요", preferredStyle: .alert)
        let save = UIAlertAction(title: "저장", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let memo = textField.text else { return }
            DispatchQueue.main.async {
                self.viewModel.saveImage(data.image, with: memo)
                self.collectionView.reloadData()
            }
        }
        alert.addAction(save)
        alert.addTextField()
        present(alert, animated: true)
    }
    
    private func showAlertOfDelete(_ data: ImageData) {
        let alert = UIAlertController(title: "즐겨찾기에서 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.viewModel.deleteImage(data.image)
                self.collectionView.reloadData()
            }
        }
        alert.addAction(delete)
        present(alert, animated: true)
    }
}
