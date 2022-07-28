//
//  RandomImageViewController.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit
import Combine

final class RandomImageViewController: UIViewController {
    
    // MARK: - ViewProperties
    private lazy var randomImageCollectionView: UICollectionView = {
        let layout = RandomImageCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = collectionViewManager
        collectionView.delegate = collectionViewManager
        layout.delegate = collectionViewManager
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        return collectionView
    }()
    
    // MARK: - Properties
    private var randomImageViewModel: RandomImageViewModelInterface?
    private var subscriptions = Set<AnyCancellable>()
    private var collectionViewManager: RandomImageCollectionViewManager?
    
    // MARK: - LifeCycle
    init(
        viewModel: RandomImageViewModelInterface,
        collectionViewManager: RandomImageCollectionViewManager
    ) {
        self.collectionViewManager = collectionViewManager
        self.randomImageViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureSubView()
        setConstraintsOfRandomImageCollectionView()
        bindingUpdateRandomImages()
        bindingCollectionViewManager()
        randomImageViewModel?.fetchNewRandomImages()
    }
}

// MARK: - UI
extension RandomImageViewController {
    private func configureNavigation() {
        navigationItem.title = "Random Images"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSubView() {
        view.addSubview(randomImageCollectionView)
    }
    
    private func setConstraintsOfRandomImageCollectionView() {
        NSLayoutConstraint.activate([
            randomImageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            randomImageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            randomImageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            randomImageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


// MARK: - binding
extension RandomImageViewController {
    private func bindingUpdateRandomImages() {
        randomImageViewModel?.updateImages
            .sink { [weak self] in
                self?.randomImageCollectionView.reloadSections(IndexSet(0...0))
            }.store(in: &subscriptions)
    }
    
    private func bindingCollectionViewManager() {
        collectionViewManager?.showAlert
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }.store(in: &subscriptions)
    }
}
