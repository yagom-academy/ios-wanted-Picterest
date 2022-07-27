//
//  FirstViewCollectionViewController.swift
//  Picterest
//
//  Created by JunHwan Kim on 2022/07/25.
//

import UIKit

class FirstCollectionViewController: UICollectionViewController {
    
    var imageListViewModel = ImageListViewModel()
    var saveImageManager = ImageManager()
    var numOfColumns = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? ImageCollectionViewLayout {
            layout.delegate = self
            layout.setNumberOfColumns(numOfColumns: 2)
            numOfColumns = layout.getNumberOfColumns()
        }
        imageListViewModel.fetchImages()
        self.collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.firstViewIdentifier)
        imageListViewModel.collectionViewUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageListViewModel.getImageCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.firstViewIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(with: imageListViewModel.imageViewModelAtIndexPath(index: indexPath.row), indexpath: indexPath.row)
        cell.imageInfoView.delegate = self
        return cell
    }
    
    
    
}

extension FirstCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / CGFloat(numOfColumns)
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension FirstCollectionViewController: ImageCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right) ) / CGFloat(numOfColumns)
        let height = width*(imageListViewModel.imageList[indexPath.row].height / imageListViewModel.imageList[indexPath.row].width)
        
        return height
    }
    
}

extension FirstCollectionViewController: ImageInfoViewDelegate {
    func saveImageButton(at index: Int) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "이미지 다운로드", message: "해당 이미지를 다운로드하시겠습니까?", preferredStyle: .alert)
        let downloadAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.saveImageManager.saveImageAndInfo(imageViewModel: self.imageListViewModel.imageViewModelAtIndexPath(index: index), memo: textField.text ?? "")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "메모"
            textField = alertTextField
        }
        alert.addAction(downloadAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
