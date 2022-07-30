//
//  SavedViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit

final class SavedViewController: UIViewController {
    private let reuseIdentifier = "SavedCell"
    private let viewModel = SavedViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - Private

extension SavedViewController {
    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedCollectionViewCell,
              let imageData = viewModel.getImage(at: indexPath.row) else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configure(with: imageData)
        
        return cell
    }
}

// MARK: - CollectionViewCellDelegate

extension SavedViewController: CollectionViewCellDelegate {
    func alert(from cell: UICollectionViewCell) {
        guard let cell = cell as? SavedCollectionViewCell,
              let index = self.collectionView.indexPath(for: cell)?.row,
              let imageData = self.viewModel.getImage(at: index) else {
            return
        }
        
        let title = "Picterest"
        let message = "사진을 삭제하시겠습니까?"
        let firstActionTitle = "취소"
        let secondActionTitle = "확인"
        
        let alertController = UIAlertController().makeAlert(title: title, message: message, style: .alert)
        let alertAction = alertController.alertActionInSavedViewController(cell: cell, imageData: imageData) {
            self.viewModel.fetch {
                self.collectionView.reloadData()
            }
            self.collectionView.reloadData()
        }
        
        alertController.addAlertAction(title: firstActionTitle, style: .default)
        alertController.addAlertAction(title: secondActionTitle, style: .default, handler: alertAction)

        present(alertController, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout,
              let imageData = viewModel.getImage(at: indexPath.row),
              let imageHeight = imageData.value(forKey: CoreDataKey.imageHeight) as? CGFloat,
              let imageWidth = imageData.value(forKey: CoreDataKey.imageWidth) as? CGFloat else {
            return CGSize()
        }
        
        flow.scrollDirection = .vertical
        
        let cellWidth = UIStyle.SavedCell.width
        let cellHeight = imageHeight * cellWidth / imageWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

