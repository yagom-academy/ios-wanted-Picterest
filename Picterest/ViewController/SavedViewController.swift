//
//  SavedViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit
import Combine

final class SavedViewController: UIViewController {
    private let reuseIdentifier = "SavedCell"
    private let viewModel = SavedViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        bind()
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch()
    }
    
}

extension SavedViewController {
    private func bind() {
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
}


extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let imageData = viewModel.getImage(at: indexPath.row),
              let originalURL = imageData.value(forKey: "originalURL") as? String,
              let imageID = imageData.value(forKey: "id") as? String,
              let memo = imageData.value(forKey: "memo") as? String else {
            print("get image data error")
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.view.imageView.loadImage(urlString: originalURL, imageID: imageID)
        cell.view.textLabel.text = memo
        
        return cell
    }
}

extension SavedViewController: CollectionViewCellDelegate {
    func alert(from cell: UICollectionViewCell) {
        let title = "Picterest"
        let message = "사진을 삭제하시겠습니까?"
        let firstActionTitle = "취소"
        let secondActionTitle = "확인"
        
        let alertController = UIAlertController().makeAlert(title: title, message: message, style: .alert)
        
        guard let index = self.collectionView.indexPath(for: cell)?.row,
              let imageData = self.viewModel.getImage(at: index) else {
            return
        }
    
        guard let cell = cell as? SavedCollectionViewCell else { return }
        let alertAction = alertController.alertActionInSavedViewController(cell: cell, imageData: imageData) {
            self.viewModel.fetch()
        }
        
        alertController.addAlertAction(title: firstActionTitle, style: .default)
        alertController.addAlertAction(title: secondActionTitle, style: .default, handler: alertAction)

        present(alertController, animated: true)
    }
    
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout,
              let imageData = viewModel.getImage(at: indexPath.row),
              let imageHeight = imageData.value(forKey: CoreDataKey.imageHeight) as? CGFloat,
              let imageWidth = imageData.value(forKey: CoreDataKey.imageWidth) as? CGFloat else {
            return CGSize()
        }
        
        flow.scrollDirection = .vertical
        
        let cellWidth = Style.SavedCell.width
        let cellHeight = imageHeight * cellWidth / imageWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

