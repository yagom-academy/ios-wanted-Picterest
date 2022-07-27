//
//  ImagesViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit
import Combine
import CoreData

final class ImagesViewController: UIViewController {
    private let reuseIdentifier = "PicterestCell"
    private let viewModel = ImagesViewModel()
    private var cancellable = Set<AnyCancellable>()
    private var layout: CustomLayout?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        bind()
        viewModel.fetch()
        layout = collectionView.collectionViewLayout as? CustomLayout
        layout?.delegate = self
        retrieveValues()
    }
}

extension ImagesViewController {
    private func bind() {
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &cancellable)
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
        
        cell.delegate = self
        cell.imageView.loadImage(urlString: viewModel.getImage(at: index)?.urls.small, imageID: viewModel.images[index].id)
        cell.indexLabel.text = "\(index)번째 사진"
        cell.saveImageButton.tintColor = .white
        return cell
    }
}

extension ImagesViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(viewModel.images[indexPath.row].height)
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.images[indexPath.row].width)
    }
}

extension ImagesViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) >= Int(scrollView.contentSize.height - scrollView.frame.size.height) {
            DispatchQueue.main.async {
                self.viewModel.increasePageIndex()
                self.viewModel.fetch()
                self.collectionView.reloadData()
            }
        }
    }

}

extension ImagesViewController: ImageCollectionViewCellDelegate {
    func alert(from cell: ImagesCollectionViewCell) {
        let title = "Picterest"
        let message = "사진을 다운 받으시겠습니까?"
        let firstActionTitle = "취소"
        let secondActionTitle = "확인"
        
        let alertController = UIAlertController().makeAlert(title: title, message: message, style: .alert, hasTextField: true)
        
        guard let index = self.collectionView.indexPath(for: cell)?.row,
              let imageInformation = self.viewModel.getImage(at: index) else {
            return
        }
    
        let alertAction = alertController.alertActionInImagesViewController(cell: cell, imageInformation: imageInformation)
        
        alertController.addAlertAction(title: firstActionTitle, style: .default)
        alertController.addAlertAction(title: secondActionTitle, style: .default, handler: alertAction)

        present(alertController, animated: true)
    }
}

extension ImagesViewController {
    
    func retrieveValues() {
        let entityName = "ImageCoreData"
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<ImageCoreData>(entityName: entityName)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let id = result.id, let memo = result.memo {
                        print("id: \(id), memo: \(memo)")
                    }
                }
            } catch {
                print("Could not retrieve")
            }
        }
    }
}
