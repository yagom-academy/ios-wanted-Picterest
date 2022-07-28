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
    private let viewModel: SavedListViewModel
    
    // MARK: - Init
    init(viewModel: SavedListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindRemovePhoto()
        
        viewModel.updateSavedList.bind { [weak self] _ in
            self?.savedList = CoreDataManager.shared.fetch()
            self?.savedListCollectionView.reloadData()
        }
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
        viewModel.starButtonTapped.bind { [weak self] sender, photoInfo, image in
            guard let _ = sender,
                  let photoInfo = photoInfo as? CoreSavedPhoto,
                  let _ = image else { return }
            
            UIAlertController.showAlert(
                self,
                title: "사진 삭제",
                isInTextField: false
            ) { _ in
                self?.viewModel.remove(savedPhoto: photoInfo)
            }
        }
        
        viewModel.isRemove.bind { [weak self] in
            if $0 {
                self?.savedList = CoreDataManager.shared.fetch()
                self?.savedListCollectionView.reloadData()
                self?.viewModel.updateStarButton.value = true
            }
        }
    }
}

// MARK: - UI Methods
private extension SavedListViewController {
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
