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

// MARK: - Method
extension RandomImageViewController {
    private func showImageSaveAlert(_ index: Int, button: UIButton, image: UIImage) {
        let alert = UIAlertController(title: nil, message: "\(index)번째 사진을 저장하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let memo = alert.textFields?[0].text else { return }
            button.isSelected = true
            self?.randomImageViewModel.saveImage(image: image, index: index)
            print(memo)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        self.present(alert, animated: true)
    }
    
    private func showImageDeleteAlert(_ index: Int, button: UIButton) {
        let alert = UIAlertController(title: nil, message: "\(index)번째 사진을 삭제하겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.randomImageViewModel.deleteImage(index: index)
            button.isSelected = false
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
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
    
    private func bindingCellStarButtonTapped(
        cell: ImageCollectionViewCell,
        index: Int
    ) {
        cell.starButtonTapped = { [weak self] button, image in
            print("tapped: \(index)번째 cell")
            if button.isSelected {
                self?.showImageDeleteAlert(index, button: button)
            } else {
                self?.showImageSaveAlert(index, button: button, image: image)
            }
        }
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
        bindingCellStarButtonTapped(cell: cell, index: indexPath.row)
        
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
