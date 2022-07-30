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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        photos = CoreDataManager.shared.load() ?? []
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photos = CoreDataManager.shared.load() ?? []
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .white
        setupCollectionView()
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

// MARK: - Extensions

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

// MARK: - UICollectionView DelegateFlowLayout Extensions

extension SavedPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let imageWidth = photos[indexPath.item].value(forKey: "width") as? CGFloat
        let imageHeight = photos[indexPath.item].value(forKey: "height") as? CGFloat
        let width = collectionView.frame.width
        let itemsPerRow: CGFloat = 1
        let widthPadding = Style.sectionInsets.left * (itemsPerRow + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = imageHeight! * width / imageWidth!
        
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
