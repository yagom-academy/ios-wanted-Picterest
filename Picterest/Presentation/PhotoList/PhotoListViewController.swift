//
//  PhotoListViewController.swift
//  Picterest
//

import UIKit

class PhotoListViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var photoListCollectionView: UICollectionView = {
        let layout = PhotoListCollectionViewLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(
            PhotoListCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    private let viewModel = PhotoListViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        viewModel.fetchPhotoList()
        bindUpdateCollectionView()
    }
}

// MARK: - PhotoListCollectionViewLayoutDelegate
extension PhotoListViewController: PhotoListCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let photo = viewModel.photoList.value[indexPath.item]
        let photoWidth = CGFloat(photo.width)
        let photoHeight = CGFloat(photo.height)
        
        let ratio = photoHeight / photoWidth
        
        return ((collectionView.bounds.width / 2) - 12) * ratio
    }
}
// MARK: - UICollectionViewDataSource
extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.photoList.value.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoListCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        
        let photo = viewModel.photoList.value[indexPath.item]
        cell.viewModel = PhotoListCollectionViewCellViewModel(photo: photo)
        cell.setupView(index: indexPath.item)
        
        return cell
    }
}

// MARK: - Bind
private extension PhotoListViewController {
    func bindUpdateCollectionView() {
        viewModel.photoList.bind { _ in
            DispatchQueue.main.async {
                self.photoListCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UI Methods
private extension PhotoListViewController {
    func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(photoListCollectionView)
        photoListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoListCollectionView
                .leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoListCollectionView
                .topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoListCollectionView
                .trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoListCollectionView
                .bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
