//
//  StarImageViewController.swift
//  Picterest
//
//  Created by J_Min on 2022/07/25.
//

import UIKit
import Combine

final class StarImageViewController: UIViewController {
    
    // MARK: - ViewProperties
    private lazy var starImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = collectionViewManager
        collectionView.delegate = collectionViewManager
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        return collectionView
    }()
    
    // MARK: - Properties
    private var starImageViewModel: StarImageViewModelInterface?
    private var subscriptions = Set<AnyCancellable>()
    private var longPressCell: UICollectionViewCell?
    private var longPressStartIndexPath: IndexPath?
    private var collectionViewManager: StarImageCollectionViewManager?
    
    // MARK: - LifeCycle
    init(
        viewModel: StarImageViewModelInterface,
        collectionViewManager: StarImageCollectionViewManager
    ) {
        self.collectionViewManager = collectionViewManager
        self.starImageViewModel = viewModel
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
        bindingViewModel()
        bindingCollectionViewManager()
        starImageViewModel?.fetcnStarImages()
        setLongPressGestureToStarImageCollectionView()
    }
}

// MARK: - UI
extension StarImageViewController {
    
    private func configureNavigation() {
        navigationItem.title = "Star Images"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSubView() {
        view.addSubview(starImageCollectionView)
    }
    
    private func setConstraintsOfRandomImageCollectionView() {
        NSLayoutConstraint.activate([
            starImageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            starImageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            starImageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starImageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Binding
extension StarImageViewController {
    private func bindingViewModel() {
        starImageViewModel?.updateImages
            .sink { [weak self] in
                self?.starImageCollectionView.reloadSections(IndexSet(0...0))
            }.store(in: &subscriptions)
    }
    
    private func bindingCollectionViewManager() {
        collectionViewManager?.showAlert
            .sink { [weak self] index in
                let alert = AlertManager(
                    alertMessage: "사진을 삭제하겠습니까?"
                ).createAlert(isSave: false) { alert in
                    self?.starImageViewModel?.deleteImageToStorage(index: index)
                }
                self?.present(alert, animated: true)
            }.store(in: &subscriptions)
    }
}

// MARK: - Method
extension StarImageViewController {
    private func setLongPressGestureToStarImageCollectionView() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPressGestureToStarImageCollectionViewAction(_:))
        )
        
        longPressGesture.minimumPressDuration = 0.2
        longPressGesture.delaysTouchesBegan = true
        starImageCollectionView.addGestureRecognizer(longPressGesture)
    }
}

// MARK: - TargetMethod
extension StarImageViewController {
    @objc private func longPressGestureToStarImageCollectionViewAction(_ sender: UILongPressGestureRecognizer) {
        let pressPoint = sender.location(in: starImageCollectionView)
        guard let indexPath = starImageCollectionView.indexPathForItem(at: pressPoint) else { return }
        
        if sender.state == .began {
            guard let cell = starImageCollectionView.cellForItem(at: indexPath) else { return }
            longPressCell = cell
            longPressStartIndexPath = indexPath
            UIView.animate(withDuration: 0.2) {
                self.longPressCell?.transform = .init(scaleX: 0.95, y: 0.95)
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.2) {
                self.longPressCell?.transform = .identity
            }
            if longPressStartIndexPath == indexPath {
                let alert = AlertManager(
                    alertMessage: "사진을 삭제하겠습니까?"
                ).createAlert(isSave: false) { [weak self] alert in
                    self?.starImageViewModel?.deleteImageToStorage(index: self?.longPressStartIndexPath?.row ?? 0)
                }
                self.present(alert, animated: true)
            }
        }
    }
}
