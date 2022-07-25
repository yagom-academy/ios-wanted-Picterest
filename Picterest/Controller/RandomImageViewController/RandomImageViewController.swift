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
        layout.delegate = self
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
    let randomImageViewModel: RandomImageViewModelInterface = RandomImageViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSubView()
        setConfigurationsOfRandomImageCollectionView()
        bindingUpdateRandomImages()
        randomImageViewModel.fetchNewImages()
    }
}

// MARK: - binding
extension RandomImageViewController {
    private func bindingUpdateRandomImages() {
        randomImageViewModel.updateRandomImages
            .sink { [weak self] in
                self?.randomImageCollectionView.reloadSections(IndexSet(0...0))
            }.store(in: &subscriptions)
    }
}

// MARK: - UI
extension RandomImageViewController {
    private func configureNavigation() {
        navigationItem.title = "Random Image"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSubView() {
        view.addSubview(randomImageCollectionView)
    }
    
    private func setConfigurationsOfRandomImageCollectionView() {
        NSLayoutConstraint.activate([
            randomImageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            randomImageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            randomImageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            randomImageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension RandomImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomImageViewModel.randomImagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let randomImage = randomImageViewModel.randomImageAtIndex(index: indexPath.row)
        cell.configureCell(with: randomImage, index: indexPath.row)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RandomImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right) - 7) / 2
        
        return CGSize(width: width, height: width)
    }
}

// MARK: - RandomImageCollectionViewLayoutDelegate
extension RandomImageViewController: RandomImageCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right) - 7) / 2
        let height = width * randomImageViewModel.randomImageAtIndex(index: indexPath.row).imageRatio
        
        return height
    }
}

// MARK: - UICollectionViewDelegate
extension RandomImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == randomImageViewModel.randomImagesCount {
            randomImageViewModel.fetchNewImages()
        }
    }
}
