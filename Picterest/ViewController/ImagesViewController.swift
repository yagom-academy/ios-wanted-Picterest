//
//  ImagesViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit
import Combine

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
        cell.delegate = self
        cell.imageView.loadImage(viewModel.getImage(of: indexPath.row).urls.small)
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
            guard let textFields = alertController.textFields else {
                return
            }
            
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
