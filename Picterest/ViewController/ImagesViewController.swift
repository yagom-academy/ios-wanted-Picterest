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
    private let imageFileManager = ImageFileManager()
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
        cell.imageView.loadImage(viewModel.getImage(at: index)?.urls.small)
        cell.indexLabel.text = "\(indexPath.row)번째 사진"
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
        let alertController = UIAlertController(title: "Picterest", message: "사진을 다운받으시겠습니까?", preferredStyle: .alert)
        alertController.addTextField()

        let save = UIAlertAction(title: "저장", style: UIAlertAction.Style.default, handler: { saveAction -> Void in
            guard let textFields = alertController.textFields,
                  let index = self.collectionView.indexPath(for: cell)?.row,
                  let imageInformation = self.viewModel.getImage(at: index),
                  let memo = textFields[0].text else {
                return
            }
            
            let imageID = imageInformation.id
            let originalURL = imageInformation.urls.small
            
            guard let savedLocation = self.imageFileManager.saveImageToDevice(fileName: imageID, cell.imageView.image) else { return }
            let imageCoreData = ImageCoreDataModel(id: imageID, memo: memo, originalURL: originalURL, savedLocation: savedLocation)
            
            CoreDataManager.shared.save(imageCoreData)
        })
        
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            print("취소")
        })


        alertController.addAction(save)
        alertController.addAction(cancel)

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
