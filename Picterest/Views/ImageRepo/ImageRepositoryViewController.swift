//
//  ImageRepositoryViewController.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

class ImageRepositoryViewController: UIViewController {
    
    private let viewModel = ImageRepositoryViewModel()
    
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
            DispatchQueue.main.async {
                self?.picturesCollectionView.reloadData()
            }
        }
        viewModel.list()
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    
        return UIContextMenuConfiguration(identifier: NSIndexPath(item: indexPath.item, section: indexPath.section), previewProvider: nil) { suggestedActions in
            let deleteAction = self.deleteAction(indexPath)
            return UIMenu(title: "", children: [deleteAction])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.contentView.bounds, cornerRadius: cell.contentView.layer.cornerRadius)

        return UITargetedPreview(view: cell, parameters: parameters)
    }
    
}

extension ImageRepositoryViewController {
    func deleteAction(_ indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "삭제",
                                    image: UIImage(systemName: "trash"),
                                    attributes: .destructive) { [self] action in
            picturesCollectionView.deleteItems(at: [indexPath])
            viewModel.deleteImage(at: indexPath)
        }
        return deleteAction
    }
}
