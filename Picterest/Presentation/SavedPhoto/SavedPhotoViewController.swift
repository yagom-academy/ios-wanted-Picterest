//
//  SavedPhotoViewController.swift
//  Picterest
//
//  Created by BH on 2022/07/27.
//

import CoreData
import UIKit

class SavedPhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var photos: [NSManagedObject] = []
    
    // MARK: - UIProperties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            SavedPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: SavedPhotoCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupLongGestureRecognizerOnCollection()
        fetchFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromCoreData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - FetchFromCoreData Method extension

extension SavedPhotoViewController {
    
    private func fetchFromCoreData() {
        photos = CoreDataManager.shared.load() ?? []
    }
    
}

// MARK: - SavedPhotoViewController Layout extension

extension SavedPhotoViewController {
    
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Saved Images"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfCollectionView()
    }
    
    private func setupConstraintsOfCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
}

// MARK: - LongPress to delete file methods extension

extension SavedPhotoViewController: UIGestureRecognizerDelegate {
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(gestureRecognizer:))
        )
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)

        if gestureRecognizer.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                let photo = photos[indexPath.item]
                let alert = UIAlertController(
                    title: "즐겨찾기 사진 삭제",
                    message: "",
                    preferredStyle: .alert
                )
                let deleteButton = UIAlertAction(
                    title: "삭제",
                    style: .destructive) { _ in
                        if let imageID = photo.value(forKey: "id") as? String {
                            self.photos.remove(at: indexPath.item)
                            CoreDataManager.shared.delete(item: photo)
                            ImageManager.shared.deleteImage(id: imageID)
                            self.collectionView.deleteItems(at: [indexPath])
                        }
                    }
                let cancelButton = UIAlertAction(
                    title: "취소",
                    style: .cancel,
                    handler: nil
                )
                alert.addAction(cancelButton)
                alert.addAction(deleteButton)
                self.present(alert, animated: true)
            }
        } else {
            return
        }
    }
    
}

// MARK: - UICollectionView DataSource extension

extension SavedPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SavedPhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? SavedPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.item]
        cell.setupCell(photo: photo)
        return cell
    }
    
}

// MARK: - UICollectionView DelegateFlowLayout extension

extension SavedPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let photo = photos[indexPath.item]
        guard let imageWidth = photo.value(forKey: "width") as? CGFloat,
              let imageHeight = photo.value(forKey: "height") as? CGFloat else {
            return CGSize(width: 0, height: 0)
        }
        let cellWidth = collectionView.frame.width * 0.9
        let cellHeight = imageHeight * cellWidth / imageWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

// MARK: - NameSpaces

extension SavedPhotoViewController {
    
    private enum Style {
        
        static let sectionInsets: UIEdgeInsets = .init(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        
    }
}
