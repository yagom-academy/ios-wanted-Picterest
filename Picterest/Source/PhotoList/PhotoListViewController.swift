//
//  PhotoListViewController.swift
//  Picterest
//
//

import UIKit

class PhotoListViewController: UIViewController {
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    private var photoList: [PhotoModel] = []
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getPhotoData()
    }
}

//MARK: - Extension: Methods

extension PhotoListViewController {
    private func setCollectionView() {
        photoListCollectionView.dataSource = self
        if let layout = photoListCollectionView.collectionViewLayout as?
            PhotoListCollectionViewLayout {
            layout.delegate = self
        }
        photoListCollectionView?.contentInset = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
        photoListCollectionView.register(
            UINib(
                nibName: "PhotoListCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "PhotoListCollectionViewCell"
        )
    }
    
    private func getPhotoData() {
        networkManager.getPhotoList { result in
            switch result {
            case .success(let data):
                self.photoList.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.photoListCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showSaveAlertMessage(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: "사진 저장",
            message: "저장할 사진에 메모를 남겨주세요",
            preferredStyle: .alert
        )
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            completion(alertController.textFields?[0].text)
        }
        alertController.addTextField()
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
    }
    
    private func showDeleteAlertMessage() {
        let alertController = UIAlertController(
            title: "사진 저장 취소",
            message: "사진 저장이 취소 되었습니다.",
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
}

//MARK: - Extension: DidTapPhotoSaveButtonDelegate

extension PhotoListViewController: DidTapPhotoSaveButtonDelegate {
    func showSavePhotoAlert(sender: UIButton, photoInfo: PhotoModel?, image: UIImage?) {
        if sender.tintColor == .systemYellow {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            sender.tintColor = .white
            guard let photoInfo = photoInfo else { return }
            ImageFileManager.shared.deleteImageFromLocal(named: (photoInfo.id) + ".png")
            // coreData 삭제
            
            showDeleteAlertMessage()
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            sender.tintColor = .systemYellow
            showSaveAlertMessage { memo in
                guard memo != nil else { return }
                guard let photoInfo = photoInfo else { return }
                guard let image = image else { return }
                ImageFileManager.shared.saveImageToLocal(image: image, name: (photoInfo.id) + ".png")
                
              //  CoreData추가
              //  메모 memo
              //  photoInfo?.urls.raw
              //  photoInfo?.id
              //  result
              //  성능적인 이슈 ->
              //  시점 ->
            }
        }
    }
}

//MARK: - Extension: CollectionView

extension PhotoListViewController: PhotoListCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let width = CGFloat(photoList[indexPath.row].width)
        let height = CGFloat(photoList[indexPath.row].height)
        return (((collectionView.frame.width - 32) / 2 ) - 10) * (height /  width)
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let photoCell = photoListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoListCollectionViewCell",
            for: indexPath
        ) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        photoCell.delegate = self
        photoCell.photoInfo = photoList[indexPath.row]
        photoCell.fetchDataFromCollectionView(data: photoList[indexPath.row])
        photoCell.captionLabel.text = "\(indexPath.row)번째 사진"
        return photoCell
    }
}
