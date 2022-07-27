//
//  SavedListViewController.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class SavedListViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var savedListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PhotoListCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Properties
    private var savedList: [CoreSavedPhoto] = CoreDataManager.shared.fetch()
    private let viewModel = SavedListViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindRemovePhoto()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SavedListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width - 32.0
        let height = width * savedList[indexPath.item].ratio
        return CGSize(width: width, height: height)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16.0
    }
}

// MARK: - UICollectionViewDataSource
extension SavedListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return savedList.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoListCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        let savedPhoto = savedList[indexPath.item]
        cell.viewModel = viewModel.makePhotoListCollectionViewCellViewModel(savedPhoto: savedPhoto)
        cell.setupView(photo: savedPhoto, index: indexPath.item)
        return cell
    }
}

// MARK: - Bind
private extension SavedListViewController {
    func bindRemovePhoto() {
        viewModel.starButtonTapped.bind { sender, photoInfo, image in
            guard let _ = sender,
                  let photoInfo = photoInfo as? CoreSavedPhoto,
                  let _ = image else { return }
            
            self.showAlert {
                self.viewModel.remove(savedPhoto: photoInfo)
            }
        }
        
        viewModel.isRemove.bind {
            if $0 {
                self.savedList = CoreDataManager.shared.fetch()
                self.savedListCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UI Methods
private extension SavedListViewController {
    func showAlert(handler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "사진 삭제",
            message: nil,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            handler()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        [cancelAction, okAction].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
    
    func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(savedListCollectionView)
        savedListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            savedListCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            savedListCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            savedListCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            savedListCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
