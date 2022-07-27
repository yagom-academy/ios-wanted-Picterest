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
        collectionView.register(imageCollectionViewCell.self,
                                forCellWithReuseIdentifier: imageCollectionViewCell.reuseIdentifier)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionViewCell.reuseIdentifier, for: indexPath) as? imageCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: imageCollectionViewModel.imageAtIndex(indexPath.row), index: indexPath.row)
        cell.delegate = self
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

extension ImagesViewController: SaveImageDelegate {
    func starButtonTapped(didSave: Bool) {
        if !didSave {
            let alert = UIAlertController(title: "사진 저장", message: "메모를 남겨보세요", preferredStyle: .alert)
            let save = UIAlertAction(title: "저장", style: .default)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(save)
            alert.addAction(cancel)
            alert.addTextField { textfield in
                textfield.placeholder = "내용을 입력해주세요"
            }
            present(alert, animated: true, completion: nil)
        }
    }
}
