//
//  SavedViewController.swift
//  Picterest
//
//  Created by CHUBBY on 2022/07/26.
//

import UIKit

final class SavedViewController: UIViewController {
    
    private let viewModel = SavedCollectionViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.register(SavedCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SavedCollectionHeaderView.identifier)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(deleteItem(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        viewModel.fetchSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.savedImagesUpdated = {
            self.collectionView.reloadData()
        }
        viewModel.refreshData()
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

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savedImagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell()}
        let savedData = viewModel.image(at: indexPath.row)
        cell.configureSavedCollectionCell(with: savedData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SavedCollectionHeaderView.identifier,
                for: indexPath
              ) as? SavedCollectionHeaderView else {
            return UICollectionReusableView()
        }
        header.configureView()
        return header
    }
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let savedImage = viewModel.image(at: indexPath.row)
        let width: CGFloat = view.frame.width - 20
        let imageRatio = CGFloat(savedImage.image.height) / CGFloat(savedImage.image.width)
        let height = (width * imageRatio)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width - 32.0, height: 80.0)
    }
}

extension SavedViewController {
    @objc func deleteItem(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let position = gestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: position) else { return }
        let alert = UIAlertController(title: "사진 삭제", message: "사진을 삭제하시겠습니까?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.viewModel.deleteData(at: indexPath.row)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
