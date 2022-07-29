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
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.fetch {
            self.collectionView.reloadData()
        }
        layout = collectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
}

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.row
        guard let imageData = viewModel.getImage(at: index) else {
            return UICollectionViewCell()
        }
    
        cell.delegate = self
        cell.view.textLabel.text = "\(index + 1)번째 사진"
        cell.view.imageView.loadImage(urlString: imageData.urls.small, imageID: imageData.id)
        if ImageFileManager.shared.fileExists(imageData.id as NSString) {
            cell.view.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.view.saveButton.tintColor = .yellow
            cell.view.isSaved = true
        }
        return cell
    }
}

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

extension ImagesViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) >= Int(scrollView.contentSize.height - scrollView.frame.size.height) {
            DispatchQueue.main.async {
                self.viewModel.increasePageIndex()
                self.viewModel.fetch {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

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

