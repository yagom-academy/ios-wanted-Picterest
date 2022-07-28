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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PhotoListCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Properties
    private let viewModel: PhotoListViewModel
    
    // MARK: - Init
    init(viewModel: PhotoListViewModel) {
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
        viewModel.fetchPhotoList(page: 1)
        bindUpdateCollectionView()
        bindSavePhoto()
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

// MARK: - UICollectionViewDelegate
extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item % 15 == 14
            && viewModel.currentPage == (indexPath.item / 15) + 1 {
            viewModel.currentPage += 1
            viewModel.fetchPhotoList(page: viewModel.currentPage)
        }
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
        cell.viewModel = viewModel.makePhotoListCollectionViewCellViewModel(photo: photo)
        cell.setupView(photo: photo, index: indexPath.item)
        
        return cell
    }
}

// MARK: - Bind
private extension PhotoListViewController {
    func bindSavePhoto() {
        viewModel.starButtonTapped.bind { [weak self] sender, photoInfo, image in
            guard let sender = sender,
                  let photoInfo = photoInfo as? Photo,
                  let image = image else { return }
            
            if !sender.isSelected {
                UIAlertController.showAlert(
                    self,
                    title: "사진 저장",
                    isInTextField: true
                ) { memo in
                    self?.viewModel.savePhoto(
                        sender: sender,
                        photoInfo: photoInfo,
                        memo: memo ?? "",
                        image: image
                    )
                }
            } else {
                UIAlertController.showAlert(
                    self,
                    title: "사진 삭제",
                    isInTextField: false
                ) { _ in
                    self?.viewModel.removePhoto(sender: sender, photoInfo: photoInfo)
                }
            }
        }
        
        viewModel.isSave.bind { [weak self] sender, isDone in
            guard let sender = sender else { return }
            if isDone {
                sender.isSelected = true
                sender.tintColor = .systemYellow
                self?.viewModel.updateSavedList.value = true
            }
        }
        viewModel.isRemove.bind { [weak self] sender, isDone in
            guard let sender = sender else { return }
            if isDone {
                sender.isSelected = false
                sender.tintColor = .white
                self?.viewModel.updateSavedList.value = true
            }
        }
    }
    func bindUpdateCollectionView() {
        viewModel.photoList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.photoListCollectionView.reloadData()
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
