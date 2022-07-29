//
//  ImagesViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit
import CoreData

final class ImagesViewController: UIViewController {
    private let reuseIdentifier = "PicterestCell"
    private let viewModel = ImagesViewModel()
    private var layout: CustomLayout?
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.fetch {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}

// MARK: - Private

extension ImagesViewController {
    private func configure() {
        configureCollectionView()
        configureLayout()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureLayout() {
        layout = collectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let imageInformation = viewModel.getImage(at: indexPath.row) else {
            return UICollectionViewCell()
        }
    
        cell.delegate = self
        cell.configure(with: imageInformation, index: indexPath.row)
        
        return cell
    }
}

// MARK: - CustomLayoutDelegate

extension ImagesViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let imageData = viewModel.getImage(at: indexPath.row) else {
            return CGFloat()
        }
        return CGFloat(imageData.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let imageData = viewModel.getImage(at: indexPath.row) else {
            return CGFloat()
        }
        return CGFloat(imageData.width)
    }
}

// MARK: - UICollectionViewDelegate

extension ImagesViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let distanceFromOriginToVisiblePoint = scrollView.contentOffset.y
        let totalHeightOfContentView = scrollView.contentSize.height
        let visibleHeightOfContentView = scrollView.frame.size.height
        
        if Int(distanceFromOriginToVisiblePoint) >= Int(totalHeightOfContentView - visibleHeightOfContentView) {
            DispatchQueue.main.async {
                self.viewModel.increasePageIndex()
                self.viewModel.fetch {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


// MARK: - CollectionViewCellDelegate

extension ImagesViewController: CollectionViewCellDelegate {
    func alert(from cell: UICollectionViewCell) {
        
        let title = "Picterest"
        let message = "사진을 다운 받으시겠습니까?"
        let firstActionTitle = "취소"
        let secondActionTitle = "확인"
        
        let alertController = UIAlertController().makeAlert(title: title, message: message, style: .alert, hasTextField: true)
        
        guard let index = self.collectionView.indexPath(for: cell)?.row,
              let imageInformation = self.viewModel.getImage(at: index) else {
            return
        }
    
        guard let cell = cell as? ImagesCollectionViewCell else { return }
        let alertAction = alertController.alertActionInImagesViewController(cell: cell, imageInformation: imageInformation)
        
        alertController.addAlertAction(title: firstActionTitle, style: .default)
        alertController.addAlertAction(title: secondActionTitle, style: .default, handler: alertAction)

        present(alertController, animated: true)
    }
}

