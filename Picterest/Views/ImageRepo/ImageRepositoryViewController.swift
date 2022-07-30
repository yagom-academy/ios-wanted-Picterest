//
//  ImageRepositoryViewController.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

final class ImageRepositoryViewController: UIViewController {
    
    private let viewModel = ImageRepositoryViewModel()
    
    private var longpressGesture: UILongPressGestureRecognizer?
    
    private let picturesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PicterestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setLayout()
        setLongpressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addViewModelObserver()
    }
    
    private func setDelegate() {
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(picturesCollectionView)
        
        NSLayoutConstraint.activate([
            
            picturesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            picturesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            picturesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picturesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func addViewModelObserver() {
        viewModel.imageListUpdate = { [weak self] in
            self?.picturesCollectionView.reloadData()
        }
        
        viewModel.list()
    }
    
    private func setLongpressGesture() {
        longpressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pictureLongPresshandler))
        guard let longpressGesture = longpressGesture else { return }
        picturesCollectionView.addGestureRecognizer(longpressGesture)
        
    }
    
    @objc func pictureLongPresshandler(guesture: UILongPressGestureRecognizer) {
        let position = guesture.location(in: picturesCollectionView)
        
        guard let indexPath = picturesCollectionView.indexPathForItem(at: position) else { return }
        guard let cell = picturesCollectionView.cellForItem(at: indexPath) else { return }
        
        switch guesture.state {
        case .began:
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform.identity
            } completion: { _ in
                self.setImageDeleteAlert(indexPath: indexPath)
            }
        default:
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
}

extension ImageRepositoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picturesCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PicterestCollectionViewCell
        let imageData = viewModel.image(at: indexPath.row)
        cell.fetchImageDataToRepository(data: imageData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: viewModel.imageSize(at: indexPath.row) * 2)
    }
    
}

extension ImageRepositoryViewController {
    
    func setImageDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: GlobalConstants.Text.Alert.askDeleteTitle, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: GlobalConstants.Text.Alert.no, style: .cancel)
        let deleteAction = UIAlertAction(title: GlobalConstants.Text.Alert.delete, style: .destructive) { [self] _ in
            viewModel.deleteImage(at: indexPath)
            picturesCollectionView.deleteItems(at: [indexPath])
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
}
