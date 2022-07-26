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
    private let starImageViewModel = StarImageViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureSubView()
        setConstraintsOfRandomImageCollectionView()
        bindingViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        starImageViewModel.fetcnStarImages()
    }
}

// MARK: - Method
extension StarImageViewController {
    private func showImageDeleteAlert(_ index: Int, button: UIButton) {
        let alert = UIAlertController(title: nil, message: "사진을 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.starImageViewModel.deleteImageToStorage(index: index)
            button.isSelected = false
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - Binding
extension StarImageViewController {
    private func bindingViewModel() {
        starImageViewModel.updateStarImages
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
                self?.showImageDeleteAlert(index, button: button)
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
        return starImageViewModel.starImageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let starImage = starImageViewModel.starImageAtIndex(index: indexPath.row)
        cell.configureCell(with: starImage)
        bindingCellStarButtonTapped(cell: cell, index: indexPath.row)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StarImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let starImage = starImageViewModel.starImageAtIndex(index: indexPath.row)
        let width = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right))
        let height = width * starImage.imageRatio
        return CGSize(width: width, height: height)
    }
}
