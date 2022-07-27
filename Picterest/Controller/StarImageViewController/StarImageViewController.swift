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
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    // MARK: - LifeCycle
    init(viewModel: StarImageViewModelInterface) {
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
        starImageViewModel?.fetcnStarImages()
        setLongPressGestureToStarImageCollectionView()
    }
}

// MARK: - Method
extension StarImageViewController {
    private func showImageDeleteAlert(_ index: Int) {
        let alert = UIAlertController(title: nil, message: "사진을 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.starImageViewModel?.deleteImageToStorage(index: index)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            UIView.animate(withDuration: 0.2) {
                self?.longPressCell?.transform = .identity
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
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
                showImageDeleteAlert(indexPath.row)
            }
        } else {
            return
        }
    }
}

// MARK: - Binding
extension StarImageViewController {
    private func bindingViewModel() {
        starImageViewModel?.updateStarImages
            .sink { [weak self] in
                self?.starImageCollectionView.reloadSections(IndexSet(0...0))
            }.store(in: &subscriptions)
    }
    
    private func bindingCellStarButtonTapped(
        cell: ImageCollectionViewCell,
        index: Int
    ) {
        cell.starButtonTapped = { [weak self] button, image in
            if button.isSelected {
                self?.showImageDeleteAlert(index)
            }
        }
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

// MARK: - UICollectionViewDataSource
extension StarImageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starImageViewModel?.starImageCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        guard let starImage = starImageViewModel?.starImageAtIndex(index: indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: starImage)
        bindingCellStarButtonTapped(cell: cell, index: indexPath.row)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StarImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let starImage = starImageViewModel?.starImageAtIndex(index: indexPath.row) else { return .zero }
        let width = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right))
        let height = width * starImage.imageRatio
        return CGSize(width: width, height: height)
    }
}
