//
//  SavedViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit
import Combine

protocol SavedViewControllerDelegate: AnyObject {
    func photoDeleteSuccess()
}

final class SavedViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case main
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: createLayoutSection())
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoEntityData>?
    
    private let savedViewModel: SavedViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    weak var delegate: SavedViewControllerDelegate?
    
    // MARK: - init Method
    
    init(savedViewModel: SavedViewModel) {
        self.savedViewModel = savedViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        savedViewModel.fetch()
    }
    
    // MARK: - Configure Method
    
    private func configure() {
        configureView()
        configureNavigation()
        addSubviews()
        makeConstraints()
        bind()
        configureDataSource()
    }
}

// MARK: - UI Method

extension SavedViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigation() {
        navigationItem.title = "Saved Images"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
        ])
    }
    
    private func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(488))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(488))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.spacing
        return section
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoEntityData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photoEntityData in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            
            cell.configureCell(photoEntityData: photoEntityData)
            return cell
        })
    }
}

// MARK: - bind Method

extension SavedViewController {
    private func bind() {
        savedViewModel.$photoEntityData
            .receive(on: DispatchQueue.main)
            .sink { photoEntityData in
                var snapShot = NSDiffableDataSourceSnapshot<Section, PhotoEntityData>()
                snapShot.appendSections([Section.main])
                snapShot.appendItems(photoEntityData)
                self.dataSource?.apply(snapShot)
            }
            .store(in: &cancellable)
    }
}

// MARK: - PhotosViewControllerDelegate

extension SavedViewController: PhotosViewControllerDelegate {
    func photoSaveSuccess() {
        savedViewModel.fetch()
    }
}

// MARK: - UICollectionViewDelegate

extension SavedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }
}

// MARK: - Method

extension SavedViewController {
    private func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let delete = UIAction(title: "보관함에서 삭제", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, attributes: .destructive, state: .off) { (_) in
                
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
                actionSheet.addAction(UIAlertAction(title: "사진 삭제", style: .destructive) { _ in
                    self.savedViewModel.deletePhotoEntityData(index: indexPath.item) {
                        self.delegate?.photoDeleteSuccess()
                    }
                })
                
                self.present(actionSheet, animated: true)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
            
        }
        return context
    }
}
